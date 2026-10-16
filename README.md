<p align="center">
  <img src="docs/img/logo-pascual-bravo.png" alt="Institución Universitaria Pascual Bravo" width="380">
</p>

<h1 align="center">Red Social Pascualina</h1>
<p align="center"><em>Proyecto de Aula — Diseño e implementación de una base de datos relacional</em></p>

<p align="center">
  <strong>Institución Universitaria Pascual Bravo</strong><br>
  Facultad de Ingeniería — Departamento de Sistemas Digitales<br>
  Base de Datos I (SD1006) · Semestre 2026-2
</p>

---

## Información del curso

| | |
|---|---|
| **Institución** | Institución Universitaria Pascual Bravo |
| **Facultad** | Ingeniería — Departamento de Sistemas Digitales |
| **Curso** | Base de Datos I (SD1006) |
| **Semestre** | 2026-2 |
| **Docente** | Jaime Ernesto Soto Urdaneta |
| **Proyecto de aula** | Red Social Pascualina |
| **Grupo** | 051 |

## Propósito del proyecto

Diseñar e implementar la base de datos relacional que soporta la **Red Social Pascualina**, avanzando de forma progresiva desde el análisis del problema hasta la manipulación de datos con SQL. El propósito no es únicamente construir tablas, sino producir un modelo que represente correctamente la realidad de la plataforma y que permita consultar, analizar y proteger la información de manera eficiente, sustentando técnicamente cada decisión de diseño.

El proyecto evoluciona durante el semestre a través de las siguientes etapas:

> Análisis del problema → Modelo conceptual → Modelo lógico → Modelo físico → DDL → DML → Consultas → Análisis de información → Validación de integridad

## Autor

| Estudiante | Programa |
|---|---|
| Juan Camilo González Hoyos | Ingeniería de Sistemas |

## Descripción del caso de estudio

La Institución Universitaria Pascual Bravo, orientada a la formación tecnológica y profesional, busca fortalecer los espacios de interacción entre los integrantes de su comunidad. En ese contexto surge la **Red Social Pascualina**, una plataforma institucional para la interacción entre estudiantes, docentes, egresados, empleados, empresarios y otros usuarios autorizados.

La plataforma permite compartir información, publicar contenidos, comentar y reaccionar, participar en grupos de interés, organizar y asistir a eventos, ofrecer y solicitar servicios, y publicar productos para su venta o adquisición. Toda esa información debe quedar organizada y almacenada de manera estructurada, garantizando su integridad, consistencia y disponibilidad.

El reto consiste en modelar correctamente estas situaciones para evitar los riesgos de un diseño deficiente: duplicidad de información, registros inconsistentes, relaciones incorrectas entre entidades, pérdida de datos, problemas de integridad referencial y bajo rendimiento de las consultas.

## Estructura del repositorio

Las carpetas están organizadas por tarea y nombradas de acuerdo con el entregable que almacenan.

```
.
├── Tarea1/                 Modelo Conceptual (EA1)
│   ├── Informe/            Informe de la propuesta de solución (.pdf)
│   └── Video/              Enlace al video de sustentación (el video no se sube al repositorio)
├── Tarea2/                 Modelo Lógico (EA2)
│   ├── Informe/            Informe de la propuesta de solución (.pdf)
│   └── Resultados/         Hoja de cálculo: normalización y diccionario de datos (.xlsx)
├── Tarea3/                 Modelo Físico (EA3)
│   ├── Informe/            Informe de la propuesta de solución (.pdf)
│   ├── Resultados/         Diccionario de datos físico (.xlsx) y scripts DDL de creación y modificación (.sql)
│   └── Video/              El video de sustentación se presentará en la Tarea 4
├── Tarea4/
├── Tarea5/
├── Tarea6/
└── docs/img/               Recursos gráficos del repositorio
```

## Entregables por tarea

| Tarea | Contenido | Estado |
|---|---|---|
| [Tarea 1](Tarea1) — Modelo Conceptual | Inventario de entidades, atributos y relaciones; diagrama E-R de Chen; análisis y conclusiones | Entregado (informe y video) |
| [Tarea 2](Tarea2) — Modelo Lógico | Normalización del modelo relacional (1FN, 2FN, 3FN) y diccionario de datos genérico | Informe y hoja de cálculo entregados · video pendiente |
| [Tarea 3](Tarea3) — Modelo Físico | Modelo físico en PostgreSQL: diccionario de datos físico y scripts DDL de creación (23 tablas) y modificación. Incluye los ajustes de la revisión con el docente (sin UUID; atributos de dos valores como BOOLEAN) | Informe, hoja de cálculo y scripts entregados · video en la Tarea 4 |
| [Tarea 4](Tarea4) | Pendiente | Pendiente |
| [Tarea 5](Tarea5) | Pendiente | Pendiente |
| [Tarea 6](Tarea6) | Pendiente | Pendiente |
