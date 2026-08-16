# Fórmula 1: Jolpica

Datos históricos de Fórmula 1 para practicar SQL. La fuente es el dump CSV público de [Jolpica F1](https://github.com/jolpica/jolpica-f1), disponible públicamente y actualizado cada 14 días

## Archivos
- `data/equipos.csv`, `data/pilotos.csv`, `data/circuitos.csv` y `data/carreras.csv`: relaciones del ejercicio.
- `data/create_f1_schema.sql`: crea y carga el esquema PostgreSQL.

Las carreras contienen únicamente sesiones principales; no se incluyen sprints.

## PostgreSQL con Docker

Levantá la base `f1-jolpica` y cargá los CSV:

```bash
docker-compose up --build -d
```

La base queda disponible en `localhost:5432`, con usuario y contraseña `admin`. Por ejemplo:

```bash
psql -h localhost -p 5432 -U admin -d f1-jolpica
```

## Créditos

Los datos provienen de [Jolpica F1](https://github.com/jolpica/jolpica-f1). Consultá sus [condiciones de dumps](https://github.com/jolpica/jolpica-f1/blob/main/docs/database_dumps.md): los datos gratuitos son para uso no comercial.