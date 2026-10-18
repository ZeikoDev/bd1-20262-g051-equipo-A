# Tarea 4 — Implementación en tres SGBD (EA4)

**Equipo E** — Juan Camilo González Hoyos (trabajo individual desde la Tarea 3).

Implementación del modelo físico de la Red Social Pascualina (23 tablas, 34 claves foráneas) en **PostgreSQL 16**, **MySQL 8.0** y **Microsoft SQL Server 2022**, con scripts de modificación para datos estructurados y semi estructurados (JSONB) en PostgreSQL.

## Contenido

| Carpeta | Archivo | Descripción |
|---|---|---|
| [Informe](Informe) | `20262-bd1-ea4-E-E-informe.pdf` | Informe con resultados (secciones 1 a 10) |
| [Diccionarios](Diccionarios) | `20262-bd1-ea4-E-E-resultados.xlsx` | Tabla comparativa de tipos, inventario de tablas y diccionarios físicos de los 3 SGBD |
| [Scripts](Scripts) | `20262-bd1-ea4-E-E-scripts-01-postgre-crea.sql` | Creación en PostgreSQL |
| | `20262-bd1-ea4-E-E-scripts-01-postgre-mod-01.sql` | Modificación de datos estructurados (12 pasos) |
| | `20262-bd1-ea4-E-E-scripts-01-postgre-mod-02.sql` | Modificación para datos semi estructurados (JSONB) |
| | `20262-bd1-ea4-E-E-scripts-02-mysql-crea.sql` | Creación en MySQL |
| | `20262-bd1-ea4-E-E-scripts-03-sqlserver-crea.sql` | Creación en MS SQL Server |
| [Video](Video) | `README.md` | Enlace al video de sustentación |

## Orden de ejecución

1. **PostgreSQL (pgAdmin4):** `01-postgre-crea` → `01-postgre-mod-01` → `01-postgre-mod-02`
2. **MySQL (MySQL Workbench):** `02-mysql-crea` (crea la base `red_social_pascualina`)
3. **SQL Server:** crear la base `red_social_pascualina`, seleccionarla y ejecutar `03-sqlserver-crea`

## Cambios frente a la Tarea 3

- Se eliminó `uuid_usuario`: la PK entera `id_usuario` ya identifica al usuario.
- `condicion_producto` (nuevo/usado) pasó a `es_nuevo BOOLEAN`.
- `CHECK (fecha_nacimiento >= '1900-01-01')`: regla determinística, válida en los tres motores.
- `clave_cifrada VARCHAR(60)`: tamaño exacto de un hash bcrypt.
