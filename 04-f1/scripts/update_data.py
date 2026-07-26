#!/usr/bin/env python3
"""Actualiza las relaciones F1 a partir del dump CSV gratuito de Jolpica.

El endpoint público publica snapshots completos con 14 días de demora, no
deltas. Este programa consulta primero sus metadatos y sólo descarga un nuevo
snapshot si cambió su SHA-256. Al recibir uno nuevo reconstruye las relaciones
para incorporar tanto filas nuevas como posibles correcciones del proveedor.
No requiere dependencias fuera de la biblioteca estándar de Python.
"""

from __future__ import annotations

import csv
import hashlib
import io
import json
import os
import shutil
import sys
import tempfile
import urllib.request
import zipfile
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable, Mapping


ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
STATE_FILE = DATA_DIR / ".jolpica_dump_state.json"
DUMPS_URL = "https://api.jolpi.ca/data/dumps/download/"

# Se validan todos los CSV publicados para detectar cambios incompatibles en
# el dump, aunque las cuatro relaciones sólo necesiten una parte de ellos.
REQUIRED_DUMP_FILES = frozenset(
    {
        "formula_one_baseteam.csv",
        "formula_one_championshipadjustment.csv",
        "formula_one_championshipsystem.csv",
        "formula_one_circuit.csv",
        "formula_one_driver.csv",
        "formula_one_driverchampionship.csv",
        "formula_one_lap.csv",
        "formula_one_penalty.csv",
        "formula_one_pitstop.csv",
        "formula_one_pointsystem.csv",
        "formula_one_round.csv",
        "formula_one_roundentry.csv",
        "formula_one_season.csv",
        "formula_one_session.csv",
        "formula_one_sessionentry.csv",
        "formula_one_team.csv",
        "formula_one_teamchampionship.csv",
        "formula_one_teamdriver.csv",
    }
)

OUTPUT_FILES = (
    "equipos.csv",
    "pilotos.csv",
    "circuitos.csv",
    "carreras.csv",
)


def request_json(url: str) -> Mapping[str, object]:
    request = urllib.request.Request(url, headers={"User-Agent": "f1-data-updater/1.0"})
    with urllib.request.urlopen(request, timeout=120) as response:
        return json.load(response)


def download(url: str, destination: Path, expected_hash: str) -> None:
    request = urllib.request.Request(url, headers={"User-Agent": "f1-data-updater/1.0"})
    digest = hashlib.sha256()
    with urllib.request.urlopen(request, timeout=300) as response, destination.open("wb") as file:
        while chunk := response.read(1024 * 1024):
            file.write(chunk)
            digest.update(chunk)
    if digest.hexdigest() != expected_hash:
        destination.unlink(missing_ok=True)
        raise ValueError("El SHA-256 del dump descargado no coincide con el publicado por Jolpica.")


def read_state() -> Mapping[str, object]:
    if not STATE_FILE.exists():
        return {}
    try:
        return json.loads(STATE_FILE.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}


def write_json_atomically(path: Path, value: Mapping[str, object]) -> None:
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", dir=path.parent, delete=False) as file:
        json.dump(value, file, ensure_ascii=False, indent=2, sort_keys=True)
        file.write("\n")
        temporary_name = file.name
    os.replace(temporary_name, path)
    path.chmod(0o644)


def rows_from_zip(archive: Path, filename: str) -> list[dict[str, str]]:
    with zipfile.ZipFile(archive) as dump:
        try:
            with dump.open(filename) as raw_file:
                return list(csv.DictReader(io.TextIOWrapper(raw_file, encoding="utf-8-sig", newline="")))
        except KeyError as error:
            raise ValueError(f"El dump no contiene {filename}.") from error


def index_by_id(rows: Iterable[dict[str, str]], name: str) -> dict[str, dict[str, str]]:
    row_list = list(rows)
    indexed = {row["id"]: row for row in row_list}
    if len(indexed) != len(row_list):
        # No se ejecuta en los datos normales; la comprobación explícita evita
        # generar relaciones ambiguas si algún dump tuviera IDs duplicados.
        raise ValueError(f"Hay IDs duplicados en {name}.")
    return indexed


def timestamp_at_or_before(timestamp: str, cutoff: datetime) -> bool:
    if not timestamp:
        return False
    value = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
    if value.tzinfo is None:
        value = value.replace(tzinfo=timezone.utc)
    return value <= cutoff


def output_csv(path: Path, fields: list[str], rows: Iterable[Mapping[str, object]]) -> None:
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", newline="", dir=path.parent, delete=False
    ) as file:
        writer = csv.DictWriter(file, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
        temporary_name = file.name
    os.replace(temporary_name, path)


def position_sort_key(value: str) -> tuple[int, int]:
    """Ordena posiciones numéricas antes que posiciones ausentes/no numéricas."""
    try:
        return (0, int(value))
    except ValueError:
        return (1, sys.maxsize)


def build_relations(archive: Path, uploaded_at: str) -> dict[str, tuple[list[str], list[dict[str, object]]]]:
    circuit_rows = rows_from_zip(archive, "formula_one_circuit.csv")
    driver_rows = rows_from_zip(archive, "formula_one_driver.csv")
    round_rows = rows_from_zip(archive, "formula_one_round.csv")
    season_rows = rows_from_zip(archive, "formula_one_season.csv")
    session_rows = rows_from_zip(archive, "formula_one_session.csv")
    entry_rows = rows_from_zip(archive, "formula_one_sessionentry.csv")
    round_entry_rows = rows_from_zip(archive, "formula_one_roundentry.csv")
    team_rows = rows_from_zip(archive, "formula_one_team.csv")
    team_driver_rows = rows_from_zip(archive, "formula_one_teamdriver.csv")
    team_championship_rows = rows_from_zip(archive, "formula_one_teamchampionship.csv")

    circuits = index_by_id(circuit_rows, "formula_one_circuit.csv")
    drivers = index_by_id(driver_rows, "formula_one_driver.csv")
    rounds = index_by_id(round_rows, "formula_one_round.csv")
    seasons = index_by_id(season_rows, "formula_one_season.csv")
    sessions = index_by_id(session_rows, "formula_one_session.csv")
    round_entries = index_by_id(round_entry_rows, "formula_one_roundentry.csv")
    teams = index_by_id(team_rows, "formula_one_team.csv")
    team_drivers = index_by_id(team_driver_rows, "formula_one_teamdriver.csv")

    main_sessions = {
        session_id: session
        for session_id, session in sessions.items()
        if session["type"] == "R"
        and session["is_cancelled"] == "f"
        and rounds[session["round_id"]]["is_cancelled"] == "f"
    }

    race_candidates: list[dict[str, object]] = []
    laps_by_session: defaultdict[str, list[int]] = defaultdict(list)
    missing_links = 0
    for entry in entry_rows:
        session = main_sessions.get(entry["session_id"])
        if session is None:
            continue
        round_entry = round_entries.get(entry["round_entry_id"])
        if round_entry is None:
            missing_links += 1
            continue
        team_driver = team_drivers.get(round_entry["team_driver_id"])
        if team_driver is None:
            missing_links += 1
            continue
        round_ = rounds[session["round_id"]]
        driver_id = team_driver["driver_id"]
        team_id = team_driver["team_id"]
        if driver_id not in drivers or team_id not in teams:
            missing_links += 1
            continue
        race_candidates.append(
            {
                "id_piloto": driver_id,
                "id_circuito": round_["circuit_id"],
                "año": seasons[round_["season_id"]]["year"],
                "cod_equipo": team_id,
                "fecha": round_["date"],
                "posicion": entry["position"],
                "vueltas_finalizadas": entry["laps_completed"],
                "puntos_ganados": entry["points"],
                "_session_entry_id": entry["id"],
            }
        )
        if entry["laps_completed"].isdigit():
            laps_by_session[entry["session_id"]].append(int(entry["laps_completed"]))
    if missing_links:
        raise ValueError(f"Hay {missing_links} resultados sin una relación necesaria en el dump.")

    # En los resultados históricos hay pilotos que figuraron en más de un
    # coche durante un mismo Gran Premio. La clave elegida para carreras no
    # puede retener ambas filas, por lo que se conserva la mejor posición
    # (número más bajo), según la regla definida para este conjunto de datos.
    candidates_by_key: defaultdict[tuple[str, str, str], list[dict[str, object]]] = defaultdict(list)
    for candidate in race_candidates:
        candidates_by_key[
            (str(candidate["id_piloto"]), str(candidate["id_circuito"]), str(candidate["fecha"]))
        ].append(candidate)
    duplicate_rows_discarded = sum(len(rows) - 1 for rows in candidates_by_key.values())
    race_rows = [
        min(
            rows,
            key=lambda row: (
                position_sort_key(str(row["posicion"])),
                int(str(row["_session_entry_id"])),
            ),
        )
        for rows in candidates_by_key.values()
    ]
    for row in race_rows:
        del row["_session_entry_id"]
    if duplicate_rows_discarded:
        print(f"Se descartaron {duplicate_rows_discarded} participaciones duplicadas, conservando la mejor posición.")

    wins: Counter[str] = Counter(
        str(row["id_piloto"]) for row in race_rows if row["posicion"] == "1"
    )

    # Un campeonato sólo se cuenta si la temporada había terminado al crearse
    # el dump. Así se evita registrar al líder de una temporada en curso como
    # campeón. Para cada temporada terminada se toma la clasificación tras la
    # última carrera principal (R), ignorando resultados sprint (SR).
    cutoff = datetime.fromisoformat(uploaded_at.replace("Z", "+00:00"))
    completed_races_by_season: defaultdict[str, list[dict[str, str]]] = defaultdict(list)
    future_race_exists: set[str] = set()
    for session in main_sessions.values():
        round_ = rounds[session["round_id"]]
        season_id = round_["season_id"]
        if timestamp_at_or_before(session["timestamp"], cutoff):
            completed_races_by_season[season_id].append(session)
        else:
            future_race_exists.add(season_id)

    final_session_by_season: dict[str, str] = {}
    for season_id, completed_sessions in completed_races_by_season.items():
        if season_id in future_race_exists:
            continue
        final_session = max(
            completed_sessions,
            key=lambda session: (int(rounds[session["round_id"]]["number"]), int(session["number"])),
        )
        final_session_by_season[season_id] = final_session["id"]

    championships: Counter[str] = Counter()
    for standing in team_championship_rows:
        season_id = standing["season_id"]
        if (
            standing["position"] == "1"
            and standing["session_id"] == final_session_by_season.get(season_id)
            and standing["team_id"] in teams
        ):
            championships[standing["team_id"]] += 1

    race_rows.sort(key=lambda row: (row["fecha"], int(row["id_piloto"])))

    # La cantidad de vueltas sí se puede inferir para una carrera a partir
    # del máximo de vueltas completadas. Como varía históricamente por
    # circuito, se usa el valor de la carrera principal más reciente que
    # tenga resultados disponibles para cada circuito.
    latest_laps_by_circuit: dict[str, tuple[str, int]] = {}
    for session_id, completed_laps in laps_by_session.items():
        if not completed_laps:
            continue
        session = main_sessions[session_id]
        round_ = rounds[session["round_id"]]
        circuit_id = round_["circuit_id"]
        candidate = (session["timestamp"], max(completed_laps))
        if circuit_id not in latest_laps_by_circuit or candidate[0] > latest_laps_by_circuit[circuit_id][0]:
            latest_laps_by_circuit[circuit_id] = candidate
    equipos = [
        {"cod_equipo": team["id"], "nombre": team["name"], "veces_campeon": championships[team["id"]]}
        for team in sorted(teams.values(), key=lambda row: int(row["id"]))
    ]
    pilotos = [
        {
            "id_piloto": driver["id"],
            "nombre": driver["forename"],
            "apellido": driver["surname"],
            "nacionalidad": driver["nationality"],
            "carreras_ganadas": wins[driver["id"]],
            "fecha_nacimiento": driver["date_of_birth"],
        }
        for driver in sorted(drivers.values(), key=lambda row: int(row["id"]))
    ]
    circuitos_output = [
        {
            "id_circuito": circuit["id"],
            "nombre_circuito": circuit["name"],
            "pais": circuit["country"],
            "vueltas": latest_laps_by_circuit.get(circuit["id"], ("", ""))[1],
        }
        for circuit in sorted(circuits.values(), key=lambda row: int(row["id"]))
    ]
    return {
        "equipos.csv": (["cod_equipo", "nombre", "veces_campeon"], equipos),
        "pilotos.csv": (
            ["id_piloto", "nombre", "apellido", "nacionalidad", "carreras_ganadas", "fecha_nacimiento"],
            pilotos,
        ),
        "circuitos.csv": (["id_circuito", "nombre_circuito", "pais", "vueltas"], circuitos_output),
        "carreras.csv": (
            [
                "id_piloto",
                "id_circuito",
                "año",
                "cod_equipo",
                "fecha",
                "posicion",
                "vueltas_finalizadas",
                "puntos_ganados",
            ],
            race_rows,
        ),
    }


def main() -> int:
    DATA_DIR.mkdir(exist_ok=True)
    overview = request_json(DUMPS_URL)
    delayed = overview["delayed_dumps"]["csv"]  # type: ignore[index]
    file_hash = delayed["file_hash"]  # type: ignore[index]
    uploaded_at = delayed["uploaded_at"]  # type: ignore[index]
    download_url = delayed["download_url"]  # type: ignore[index]
    if not all((DATA_DIR / name).is_file() for name in OUTPUT_FILES) or read_state().get("file_hash") != file_hash:
        temporary_dir = Path(tempfile.mkdtemp(prefix=".jolpica_dump_", dir=DATA_DIR))
        try:
            archive = temporary_dir / "jolpica.csv.zip"
            print(f"Descargando dump CSV publicado el {uploaded_at}…")
            download(str(download_url), archive, str(file_hash))
            with zipfile.ZipFile(archive) as dump:
                files = {Path(name).name for name in dump.namelist() if not name.endswith("/")}
            missing = REQUIRED_DUMP_FILES - files
            if missing:
                raise ValueError(f"Faltan CSV requeridos en el dump: {', '.join(sorted(missing))}")
            for name, (fields, rows) in build_relations(archive, str(uploaded_at)).items():
                output_csv(DATA_DIR / name, fields, rows)
            write_json_atomically(
                STATE_FILE,
                {"file_hash": file_hash, "uploaded_at": uploaded_at, "source": "Jolpica delayed CSV dump"},
            )
            print("Datos actualizados en data/.")
        finally:
            shutil.rmtree(temporary_dir, ignore_errors=True)
    else:
        print("Los cuatro CSV ya corresponden al último dump gratuito disponible; no hay datos nuevos.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, KeyError, urllib.error.URLError, zipfile.BadZipFile) as error:
        print(f"Error al actualizar datos: {error}", file=sys.stderr)
        raise SystemExit(1)
