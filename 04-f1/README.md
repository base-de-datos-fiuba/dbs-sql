# Fórmula 1: Jolpica

Datos históricos de Fórmula 1 para practicar álgebra relacional y SQL. La fuente es el dump CSV público de [Jolpica F1](https://github.com/jolpica/jolpica-f1), disponible públicamente y actualizado cada 14 días

## Archivos
- `data/equipos.csv`, `data/pilotos.csv`, `data/circuitos.csv` y `data/carreras.csv`: relaciones del ejercicio.
- `data/formula1.relax`: las relaciones en el formato de datasets de ReLaX.
- `scripts/create_f1_schema.sql`: crea y carga el esquema PostgreSQL.

Las carreras contienen únicamente sesiones principales; no se incluyen sprints.

## ReLaX

1. Abrí [`data/formula1.relax`](data/formula1.relax), copiá todo su contenido y cargalo como dataset personalizado en [ReLaX](https://dbis-uibk.github.io/relax/).
2. Las relaciones disponibles son `equipos`, `pilotos`, `circuitos` y `carreras`.

Ejecutá `make relax` si necesitás regenerar el archivo.

## PostgreSQL con Docker

Levantá la base `f1-jolpica` y cargá los CSV:

```bash
make db
```

La base queda disponible en `localhost:5432`, con usuario y contraseña `admin`. Por ejemplo:

```bash
psql -h localhost -p 5432 -U admin -d f1-jolpica
```

## Créditos

Los datos provienen de [Jolpica F1](https://github.com/jolpica/jolpica-f1). Consultá sus [condiciones de dumps](https://github.com/jolpica/jolpica-f1/blob/main/docs/database_dumps.md): los datos gratuitos son para uso no comercial.

## Extra
Para actualizar los datos si hiciera falta:

```bash
make update
```
`scripts/update_data.py`: actualiza los CSV desde Jolpica.
`scripts/export_relax.py`: genera el archivo de ReLaX a partir de los CSV.

El script de inicialización sólo carga datos cuando el volumen es nuevo. Para reconstruir la base después de actualizar los CSV, usá `make db-reset`; este comando elimina el volumen local de PostgreSQL. Para detenerla sin borrar datos, usá `make db-down`.