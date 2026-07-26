CREATE TABLE equipos (
    cod_equipo INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    veces_campeon INTEGER NOT NULL
);

CREATE TABLE pilotos (
    id_piloto INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    nacionalidad TEXT,
    carreras_ganadas INTEGER NOT NULL,
    fecha_nacimiento DATE
);

CREATE TABLE circuitos (
    id_circuito INTEGER PRIMARY KEY,
    nombre_circuito TEXT NOT NULL,
    pais TEXT,
    vueltas INTEGER
);

CREATE TABLE carreras (
    id_piloto INTEGER NOT NULL REFERENCES pilotos(id_piloto),
    id_circuito INTEGER NOT NULL REFERENCES circuitos(id_circuito),
    anio INTEGER NOT NULL,
    cod_equipo INTEGER NOT NULL REFERENCES equipos(cod_equipo),
    fecha DATE NOT NULL,
    posicion INTEGER,
    vueltas_finalizadas INTEGER,
    puntos_ganados NUMERIC,
    PRIMARY KEY (id_piloto, id_circuito, fecha)
);

COPY equipos (cod_equipo, nombre, veces_campeon)
FROM '/data/equipos.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY pilotos (id_piloto, nombre, apellido, nacionalidad, carreras_ganadas, fecha_nacimiento)
FROM '/data/pilotos.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY circuitos (id_circuito, nombre_circuito, pais, vueltas)
FROM '/data/circuitos.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY carreras (id_piloto, id_circuito, anio, cod_equipo, fecha, posicion, vueltas_finalizadas, puntos_ganados)
FROM '/data/carreras.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
