--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Datos semi estructurados (JSONB)
-- Todas las instrucciones se deben realizar en secuencia sin errores
--

-- perfil_extendido: cada tipo de usuario guarda datos distintos
-- (estudiante: habilidades y materias; docente: investigación; empresario: ofertas)
ALTER TABLE usuario
    ADD COLUMN perfil_extendido JSONB NOT NULL DEFAULT '{}'::JSONB;

ALTER TABLE usuario
    ADD CONSTRAINT ck_usuario_perfil_extendido_objeto
    CHECK (jsonb_typeof(perfil_extendido) = 'object');

-- índice GIN para buscar dentro del JSON
CREATE INDEX ix_usuario_perfil_extendido
    ON usuario USING GIN (perfil_extendido);

-- Otro dato semi estructurado: ubicación del evento
ALTER TABLE evento
    ADD COLUMN ubicacion_geo JSONB;

ALTER TABLE evento
    ADD CONSTRAINT ck_evento_ubicacion_geo CHECK (
        ubicacion_geo IS NULL OR (
            jsonb_typeof(ubicacion_geo -> 'lat') = 'number' AND
            jsonb_typeof(ubicacion_geo -> 'lon') = 'number' AND
            (ubicacion_geo ->> 'lat')::NUMERIC BETWEEN -90 AND 90 AND
            (ubicacion_geo ->> 'lon')::NUMERIC BETWEEN -180 AND 180));

-- Tabla nueva: registro de actividad (app, web y dispositivos IoT)
CREATE TABLE registro_actividad (
    id_registro       BIGINT       GENERATED ALWAYS AS IDENTITY,
    id_usuario        INTEGER,
    tipo_actividad    VARCHAR(30)  NOT NULL,
    origen            SMALLINT     NOT NULL DEFAULT 1,
    fecha_registro    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datos_actividad   JSONB        NOT NULL DEFAULT '{}'::JSONB,
    CONSTRAINT pk_registro_actividad PRIMARY KEY (id_registro),
    CONSTRAINT fk_registro_actividad_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_registro_actividad_origen CHECK (origen BETWEEN 1 AND 3),  -- 1 web, 2 móvil, 3 IoT
    CONSTRAINT ck_registro_actividad_datos CHECK (jsonb_typeof(datos_actividad) = 'object')
);

CREATE INDEX ix_registro_actividad_fecha ON registro_actividad (fecha_registro);
CREATE INDEX ix_registro_actividad_datos ON registro_actividad USING GIN (datos_actividad);

--
-- Datos de ejemplo
--
INSERT INTO rol (nombre_rol, descripcion_rol)
VALUES ('administrador', 'Gestiona catálogos y usuarios'),
       ('miembro', 'Usuario estándar de la Red');

INSERT INTO tipo_usuario (nombre_tipo_usuario)
VALUES ('estudiante'), ('docente'), ('empresario');

-- Estudiante
INSERT INTO usuario (id_tipo_usuario, id_rol, numero_documento, nombres_usuario, apellidos_usuario,
                     correo_electronico, perfil_extendido)
VALUES (1, 2, '1001001001', 'Ana', 'Torres', 'ana.torres@pascualbravo.edu.co',
'{
  "intereses": ["programación", "videojuegos", "IA"],
  "habilidades": [
    {"nombre": "Python", "nivel": "intermedio"},
    {"nombre": "SQL", "nivel": "básico"}
  ],
  "materias_actuales": ["Bases de Datos I", "Algoritmos"],
  "disponibilidad": {"dias": ["lunes", "miércoles"], "horario": "tarde"}
}');

-- Docente
INSERT INTO usuario (id_tipo_usuario, id_rol, numero_documento, nombres_usuario, apellidos_usuario,
                     correo_electronico, perfil_extendido)
VALUES (2, 1, '7002002002', 'Carlos', 'Gómez', 'carlos.gomez@pascualbravo.edu.co',
'{
  "lineas_investigacion": ["Big Data", "IoT"],
  "publicaciones": [
    {"titulo": "Análisis de Datos", "anio": 2023},
    {"titulo": "IoT en educación", "anio": 2024}
  ],
  "disponibilidad_tutoria": {"dias": ["martes", "jueves"], "horario": "mañana"}
}');

-- Empresario
INSERT INTO usuario (id_tipo_usuario, id_rol, numero_documento, nombres_usuario, apellidos_usuario,
                     correo_electronico, perfil_extendido)
VALUES (3, 2, '9003003003', 'Laura', 'Restrepo', 'laura@techmed.co',
'{
  "empresa": "TechMed SAS",
  "sector": "software",
  "intereses_comerciales": ["practicantes", "patrocinio de hackatones"],
  "ofertas": [{"cargo": "Desarrollador junior", "modalidad": "híbrido"}]
}');

-- Evento con ubicación geográfica
INSERT INTO tipo_evento (id_usuario_registra, nombre_tipo_evento) VALUES (2, 'taller');

INSERT INTO evento (id_usuario_organizador, id_tipo_evento, nombre_evento, fecha_inicio, fecha_fin,
                    lugar_evento, cupo_maximo, ubicacion_geo)
VALUES (2, 1, 'Taller de JSONB en PostgreSQL', '2026-11-05 14:00', '2026-11-05 17:00',
        'Bloque 7, sala de cómputo', 30,
        '{"lat": 6.2795, "lon": -75.5850, "sede": "Robledo"}');

INSERT INTO registro_actividad (id_usuario, tipo_actividad, origen, datos_actividad)
VALUES (1, 'inicio_sesion', 2, '{"dispositivo": "Android", "version_app": "1.4.2", "ip": "10.0.4.21"}'),
       (1, 'ingreso_evento', 3, '{"id_evento": 1, "lector": "LEC-07", "lat": 6.2795, "lon": -75.5850, "bateria": 87}'),
       (3, 'vista_publicacion', 1, '{"id_publicacion": 15, "segundos": 42, "navegador": "Chrome"}');

--
-- Consultas
--

-- Usuarios por tipo
SELECT u.id_usuario, u.nombres_usuario, t.nombre_tipo_usuario
FROM usuario u JOIN tipo_usuario t ON t.id_tipo_usuario = u.id_tipo_usuario
WHERE t.nombre_tipo_usuario = 'estudiante';

-- Usuarios interesados en "IA"
SELECT nombres_usuario, perfil_extendido -> 'intereses' AS intereses
FROM usuario
WHERE perfil_extendido -> 'intereses' ? 'IA';

-- Habilidades de cada usuario
SELECT nombres_usuario, perfil_extendido -> 'habilidades' AS habilidades
FROM usuario
WHERE perfil_extendido ? 'habilidades';

-- Docentes con línea de investigación en IoT
SELECT nombres_usuario, perfil_extendido ->> 'lineas_investigacion' AS lineas
FROM usuario
WHERE perfil_extendido @> '{"lineas_investigacion": ["IoT"]}';

-- Eventos con sus coordenadas
SELECT nombre_evento,
       (ubicacion_geo ->> 'lat')::NUMERIC AS latitud,
       (ubicacion_geo ->> 'lon')::NUMERIC AS longitud,
       ubicacion_geo ->> 'sede' AS sede
FROM evento
WHERE ubicacion_geo IS NOT NULL;

-- Lecturas de dispositivos IoT con batería menor a 90 %
SELECT id_registro, fecha_registro, datos_actividad ->> 'lector' AS lector,
       (datos_actividad ->> 'bateria')::INTEGER AS bateria
FROM registro_actividad
WHERE origen = 3 AND (datos_actividad ->> 'bateria')::INTEGER < 90;
