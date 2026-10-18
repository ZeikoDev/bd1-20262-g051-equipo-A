--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
--

--
-- Modificación de Tablas
-- Tabla nueva: convocatoria (convocatorias que publican los grupos: semilleros, hackatones, monitorías)
--

-- 1
-- Crear una tabla "nueva" de su iniciativa
--
CREATE TABLE convocatoria ();

-- 2
-- Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
--
ALTER TABLE convocatoria
    ADD COLUMN id_convocatoria INTEGER GENERATED ALWAYS AS IDENTITY,
    ADD CONSTRAINT pk_convocatoria PRIMARY KEY (id_convocatoria);

ALTER TABLE convocatoria
    ADD COLUMN titulo_convocatoria      VARCHAR(100) NOT NULL,
    ADD COLUMN descripcion_convocatoria TEXT,
    ADD COLUMN numero_plazas            INTEGER;

-- 3
-- Quitar uno de los campos de la tabla "nueva"
--
ALTER TABLE convocatoria
    DROP COLUMN descripcion_convocatoria;

-- 4
-- Cambiar el nombre de la tabla "nueva" a otro nombre
--
ALTER TABLE convocatoria
    RENAME TO convocatoria_grupo;

ALTER TABLE convocatoria_grupo
    RENAME CONSTRAINT pk_convocatoria TO pk_convocatoria_grupo;

-- 5
-- Agregar un campo único a la tabla
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN codigo_convocatoria VARCHAR(12) NOT NULL,
    ADD CONSTRAINT uk_convocatoria_grupo_codigo UNIQUE (codigo_convocatoria);

-- 6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    ADD COLUMN fecha_fin    DATE NOT NULL DEFAULT CURRENT_DATE,
    ADD CONSTRAINT ck_convocatoria_grupo_fechas CHECK (fecha_fin >= fecha_inicio);

-- 7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--
ALTER TABLE convocatoria_grupo
    ADD COLUMN numero_postulados INTEGER NOT NULL DEFAULT 0,
    ADD CONSTRAINT ck_convocatoria_grupo_postulados CHECK (numero_postulados >= 0);

-- 8
-- Modificar el tamaño de un campo texto de la tabla renombrada
--
ALTER TABLE convocatoria_grupo
    ALTER COLUMN titulo_convocatoria TYPE VARCHAR(150);

-- 9
-- Modificar el campo numérico y colocar un control de rango
--
ALTER TABLE convocatoria_grupo
    ALTER COLUMN numero_plazas TYPE SMALLINT,
    ALTER COLUMN numero_plazas SET DEFAULT 1,
    ALTER COLUMN numero_plazas SET NOT NULL,
    ADD CONSTRAINT ck_convocatoria_grupo_plazas CHECK (numero_plazas BETWEEN 1 AND 100);

-- 10
-- Agregar un índice a la tabla
--
CREATE INDEX ix_convocatoria_grupo_fecha_inicio
    ON convocatoria_grupo (fecha_inicio);

-- 11
-- Eliminar una de las fechas (primero el CHECK que la usa)
--
ALTER TABLE convocatoria_grupo
    DROP CONSTRAINT ck_convocatoria_grupo_fechas;

ALTER TABLE convocatoria_grupo
    DROP COLUMN fecha_fin;

-- 12
-- Borrar todos los datos de una tabla sin dejar traza
--
INSERT INTO convocatoria_grupo (titulo_convocatoria, numero_plazas, codigo_convocatoria, fecha_inicio, numero_postulados)
VALUES ('Semillero de Bases de Datos 2026-2', 10, 'CONV-001', '2026-10-20', 4),
       ('Equipo para hackatón Pascual Bravo', 5, 'CONV-002', '2026-11-03', 2);

SELECT * FROM convocatoria_grupo;

TRUNCATE TABLE convocatoria_grupo RESTART IDENTITY;
