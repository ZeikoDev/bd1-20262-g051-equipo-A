--
-- Scripts de Modificación de la Base de Datos
-- Proyecto de Aula: Red Social Pascualina - Equipo A - EA3 - PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Prerrequisito: haber ejecutado 20262-bd1-ea3-equipo-A-scripts-crea.sql
--

--
-- Modificación de Tablas
--

--
-- 1.1.- Agregar un campo a la tabla de usuarios de la red social
-- Se agrega el programa académico del usuario (texto corto, opcional)
--
ALTER TABLE usuario
    ADD COLUMN programa_academico VARCHAR(80);

--
-- 1.2.- Modificar un campo de la tabla de usuarios
-- El teléfono pasa de VARCHAR(15) a VARCHAR(20) para admitir indicativo internacional (+57 ...)
--
ALTER TABLE usuario
    ALTER COLUMN telefono_usuario TYPE VARCHAR(20);

--
-- Gestionar una tabla "nueva"
-- Tabla elegida: convocatoria -> registra las convocatorias que publican los grupos
-- (semilleros, hackatones, monitorías) para que otros usuarios se postulen.
--

-- 1.3.1
-- Crear una tabla "nueva" de su iniciativa
-- (en PostgreSQL una tabla puede crearse sin columnas y luego se le agregan)
--
CREATE TABLE convocatoria ();

-- 1.3.2
-- Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
-- Mínimo un campo tipo texto y uno numérico
--
ALTER TABLE convocatoria
    ADD COLUMN id_convocatoria INTEGER GENERATED ALWAYS AS IDENTITY,
    ADD CONSTRAINT pk_convocatoria PRIMARY KEY (id_convocatoria);

ALTER TABLE convocatoria
    ADD COLUMN titulo_convocatoria      VARCHAR(100) NOT NULL,   -- texto
    ADD COLUMN descripcion_convocatoria TEXT,                    -- texto
    ADD COLUMN numero_plazas            INTEGER;                 -- numérico

-- 1.3.3
-- Quitar uno de los campos de la tabla "nueva"
--
ALTER TABLE convocatoria
    DROP COLUMN descripcion_convocatoria;

-- 1.3.4
-- Cambiar el nombre de la tabla "nueva" a otro nombre "otro_nombre"
-- Todas las operaciones siguientes se realizan sobre la tabla renombrada
--
ALTER TABLE convocatoria
    RENAME TO convocatoria_grupo;

-- (se renombra también la PK para conservar la nomenclatura pk_<tabla>)
ALTER TABLE convocatoria_grupo
    RENAME CONSTRAINT pk_convocatoria TO pk_convocatoria_grupo;

-- 1.3.5
-- Agregar un campo único a la tabla
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN codigo_convocatoria VARCHAR(12) NOT NULL,
    ADD CONSTRAINT uk_convocatoria_grupo_codigo UNIQUE (codigo_convocatoria);

-- 1.3.6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    ADD COLUMN fecha_fin    DATE NOT NULL DEFAULT CURRENT_DATE,
    ADD CONSTRAINT ck_convocatoria_grupo_fechas CHECK (fecha_fin >= fecha_inicio);

-- 1.3.7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN numero_postulados INTEGER NOT NULL DEFAULT 0,
    ADD CONSTRAINT ck_convocatoria_grupo_postulados CHECK (numero_postulados >= 0);

-- 1.3.8
-- Modificar el tamaño de un campo texto de la tabla renombrada
-- titulo_convocatoria pasa de VARCHAR(100) a VARCHAR(150)
--
ALTER TABLE convocatoria_grupo
    ALTER COLUMN titulo_convocatoria TYPE VARCHAR(150);

-- 1.3.7 (bis)
-- Modificar el campo numérico y colocar un control de rango
-- numero_plazas pasa de INTEGER a SMALLINT, obligatorio, entre 1 y 100
--
ALTER TABLE convocatoria_grupo
    ALTER COLUMN numero_plazas TYPE SMALLINT,
    ALTER COLUMN numero_plazas SET DEFAULT 1,
    ALTER COLUMN numero_plazas SET NOT NULL,
    ADD CONSTRAINT ck_convocatoria_grupo_plazas CHECK (numero_plazas BETWEEN 1 AND 100);

-- 1.3.8 (bis)
-- Agregar un índice a la tabla (cualquier campo)
-- Índice sobre fecha_inicio: las convocatorias se consultan por fecha
--
CREATE INDEX ix_convocatoria_grupo_fecha_inicio
    ON convocatoria_grupo (fecha_inicio);

--
-- 1.3.9
-- Eliminar una de las fechas
-- Primero se elimina la restricción que la usa y luego la columna
--
ALTER TABLE convocatoria_grupo
    DROP CONSTRAINT ck_convocatoria_grupo_fechas;

ALTER TABLE convocatoria_grupo
    DROP COLUMN fecha_fin;

-- 1.3.10
-- Borrar todos los datos de una tabla sin dejar traza
--
-- (datos de prueba para evidenciar el borrado)
INSERT INTO convocatoria_grupo (titulo_convocatoria, numero_plazas, codigo_convocatoria, fecha_inicio, numero_postulados)
VALUES ('Semillero de Bases de Datos 2026-2', 10, 'CONV-001', '2026-10-20', 4),
       ('Equipo para hackatón Pascual Bravo', 5, 'CONV-002', '2026-11-03', 2);

SELECT * FROM convocatoria_grupo;
-- TRUNCATE no registra borrado fila por fila (no dispara triggers DELETE) y
-- RESTART IDENTITY reinicia el contador de la clave primaria.
--
TRUNCATE TABLE convocatoria_grupo RESTART IDENTITY;

--
-- Fin del script de modificación
--
