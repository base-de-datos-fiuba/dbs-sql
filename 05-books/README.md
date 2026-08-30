# Goodreads — base PostgreSQL normalizada

Este proyecto transforma el **Goodreads Cleaned Dataset** en una base de datos
PostgreSQL sencilla para cursos introductorios.

## Origen y alcance

- Fuente: [Cleaned Goodreads Books Dataset — Kaggle](https://www.kaggle.com/datasets/ishanrealstate/goodreads-cleaned-dataset/data).
- Publisher: Ishan RealState.
- Licencia: **MIT**.
- Fecha de descarga: 2026-01-30

## Modelo

| Tabla | Propósito |
| --- | --- |
| `autores` | Catálogo de autores. |
| `libros` | Datos propios de cada libro y el `goodreads_id` de trazabilidad. |
| `autores_libros` | Relación N:N entre autores y libros. |
| `generos` | Catálogo de géneros. |
| `generos_libros` | Relación N:N entre géneros y libros. |

## Versiones generadas

Los archivos están en `03_export/`.

| Versión | Libros | Autores | Géneros | Relaciones autor–libro | Relaciones género–libro |
| --- | ---: | ---: | ---: | ---: | ---: |
| Completa | 1.769.769 | 573.289 | 1.452 | 1.769.769 | 6.475.554 |
| Didáctica | 75.000 | 58.177 | 1.195 | 75.000 | 274.526 |

La selección didáctica es reproducible: se toman los 75.000 libros válidos
con el valor hexadecimal menor de `SHA-256(goodreads_id)`, con desempate por
`goodreads_id`.

## Restauración

### SQL plano

En una base vacía:

```bash
createdb goodreads
psql -d goodreads -f 03_export/goodreads.sql
```

Para la versión de aula:

```bash
createdb goodreads_small
psql -d goodreads_small -f 03_export/goodreads_small.sql
```

### Dump custom de PostgreSQL

```bash
createdb goodreads
pg_restore --no-owner --no-privileges -d goodreads 03_export/goodreads.dump
```

Para la versión didáctica, sustituir el archivo por
`03_export/goodreads_small.dump`.

Después de restaurar, ejecutar:

```bash
psql -d goodreads -f 04_validation/validate_postgres.sql
```

## Regenerar los artefactos

Se requieren Python 3.12+, `duckdb` y `pyarrow`:

```bash
python -m pip install duckdb pyarrow
python 01_inspection/inspect_dataset_duckdb.py \
  --input raw/books_clean.parquet \
  --output-dir 01_inspection
python 02_transform/build_goodreads.py \
  --input raw/books_clean.parquet \
  --output-dir 03_export \
  --version both --small-size 75000
```

Los comandos anteriores vuelven a generar los dos SQL planos. Para crear los
archivos `.dump`, primero se restaura cada SQL y luego se ejecuta `pg_dump -Fc`.

## Validación realizada

La versión didáctica se restauró correctamente con `psql` en PostgreSQL 16 y
se generó su dump custom. La versión completa se restauró con `psql`; sus
conteos, relaciones duplicadas, libros sin autor/género y catálogos huérfanos
fueron comprobados. La restauración del dump completo con `pg_restore` se
documenta junto con los resultados en `04_validation/`.

Las consultas para clase están en [`sample_queries.sql`](sample_queries.sql).
