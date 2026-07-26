#!/usr/bin/env python3
"""Convierte los CSV normalizados en un grupo de tablas para ReLaX.

El archivo generado usa el formato de datasets estáticos de ReLaX. Puede
cargarse desde un GitHub Gist o incorporarse al archivo ``data/local_groups``
de una instalación propia de ReLaX.
"""

from __future__ import annotations

import csv
import os
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
OUTPUT = DATA_DIR / "formula1.relax"

RELATIONS = (
    ("equipos", "equipos.csv", ("cod_equipo", "nombre", "veces_campeon")),
    (
        "pilotos",
        "pilotos.csv",
        ("id_piloto", "nombre", "apellido", "nacionalidad", "carreras_ganadas", "fecha_nacimiento"),
    ),
    ("circuitos", "circuitos.csv", ("id_circuito", "nombre_circuito", "pais", "vueltas")),
    (
        "carreras",
        "carreras.csv",
        # ``anio`` es la forma ASCII de la columna CSV ``año`` para que sea
        # un identificador portable en las expresiones de álgebra relacional.
        ("id_piloto", "id_circuito", "anio", "cod_equipo", "fecha", "posicion", "vueltas_finalizadas", "puntos_ganados"),
    ),
)

NUMERIC_COLUMNS = frozenset(
    {
        "cod_equipo",
        "veces_campeon",
        "id_piloto",
        "carreras_ganadas",
        "id_circuito",
        "vueltas",
        "anio",
        "posicion",
        "vueltas_finalizadas",
        "puntos_ganados",
    }
)
DATE_COLUMNS = frozenset({"fecha", "fecha_nacimiento"})


def relax_string(value: str) -> str:
    """
    Devuelve un literal de texto compatible con ReLaX.
    """
    return "'" + value.replace("'", " ").replace("\\", "\\\\") + "'"


def relax_value(value: str, column: str) -> str:
    if not value:
        return "null"
    if column in NUMERIC_COLUMNS or column in DATE_COLUMNS:
        return value
    return relax_string(value)


def write_relation(output, relation_name: str, csv_name: str, output_columns: tuple[str, ...]) -> int:
    source = DATA_DIR / csv_name
    if not source.is_file():
        raise FileNotFoundError(f"No existe {source}. Ejecutá primero `make update`.")

    with source.open(encoding="utf-8", newline="") as file:
        reader = csv.DictReader(file)
        expected_input = tuple("año" if column == "anio" else column for column in output_columns)
        if reader.fieldnames != list(expected_input):
            raise ValueError(
                f"{source} tiene columnas {reader.fieldnames}; se esperaban {list(expected_input)}."
            )
        output.write(f"{relation_name} = {{{', '.join(output_columns)}\n")
        count = 0
        for row in reader:
            values = [relax_value(row[input_column], output_column) for input_column, output_column in zip(expected_input, output_columns)]
            output.write("    " + ", ".join(values) + "\n")
            count += 1
        output.write("}\n\n")
        return count


def main() -> int:
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", newline="\n", dir=DATA_DIR, delete=False) as file:
        file.write("group:Formula 1 (Jolpica)\n")
        file.write("description[[Relaciones de Formula 1 obtenidas del dump CSV gratuito de jolpica-f1 y transformadas para practicar algebra relacional.]]\n\n")
        counts = [write_relation(file, *relation) for relation in RELATIONS]
        temporary_name = file.name
    os.replace(temporary_name, OUTPUT)
    OUTPUT.chmod(0o644)
    print(f"Dataset ReLaX creado en {OUTPUT} ({', '.join(str(count) for count in counts)} filas).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
