# Plantilla de mockup — `NNNN-feature.html`

> **Qué es:** representación visual de una pantalla o flujo **antes** de construirlo: cómo se ve y cómo se navega. Sirve para validar diseño y experiencia con el responsable antes del primer código.
> **Reglas:** un archivo `NNNN-feature.html` **autocontenido** (sin dependencias externas) y **navegable**, con el **mismo número que su spec** · cubre **estados**, no solo el *happy path* · reutiliza el sistema de diseño · desechable e iterativo · **la aprobación del responsable es el gate** para codificar · en arreglos sobre lo existente basta una captura antes/después.
> **No va aquí:** la lógica ni los contratos de datos (→ `03-specs/NNNN-feature.md`).

## Estructura obligatoria del HTML

Cada mockup tiene dos partes:

1. **Barra del mockup** (fuera de la pantalla): número, nombre, enlaces a la spec y a la HU, y un **selector de estados**.
2. **Ficha del mockup** (desplegable) con las 7 secciones:

| # | Sección | Contenido |
|---|---|---|
| 1 | Objetivo y pantalla | Qué resuelve la pantalla, para qué rol, tamaño del marco. |
| 2 | Flujo / navegación | De dónde se llega y a dónde se va (con enlaces a otros mockups). |
| 3 | Estados | Vacío, carga, error, éxito y los propios de la pantalla. Cada uno visible desde el selector. |
| 4 | Componentes reutilizados | Primitivas del sistema de diseño que usa. |
| 5 | Responsive | Breakpoints y qué cambia en móvil. |
| 6 | Notas de interacción | Comportamientos que el código debe respetar (foco, teclado, accesibilidad, deshabilitados). |
| 7 | Aprobación del responsable | Responsable, estado, fecha y observaciones. |

## Sistema de diseño (de la guía de Figma, Actividad 4)

| Elemento | Valor |
|---|---|
| Marcos | Escritorio 1440 × 900 (inicio de sesión) y 1440 × 1024 (pantallas internas) |
| Fuente | Inter (con respaldo `system-ui`). Títulos 24–28 px Bold · tarjetas 14–16 px SemiBold · texto 14 px · ayudas 12 px |
| Color principal | `#0B3D66` — barra superior, botón principal, opción seleccionada |
| Color de apoyo | `#F2A900` — logo, contador de pendientes, foco visible |
| Textos | `#1F2933` principal · `#5B6770` secundario |
| Fondos y bordes | Fondo `#F4F6F9` · tarjetas `#FFFFFF` · bordes `#D5DDE5` · azul claro `#E7EEF5` |
| Estados | Error `#C62828` / `#FDECEC` · Éxito `#2E7D32` / `#E8F5E9` · Borrador `#8A6100` / `#FFF4D6` |
| Medidas | Barra superior 64 px · menú lateral 260 px · márgenes 32 px · campos y botones 44 px · esquinas 8 px (12 px en tarjetas) |
| Componentes | Botón principal, botón secundario, campo de texto (normal y error), alerta, opción de escala 1–5 (normal, seleccionada, error), etiqueta de estado (En curso, Borrador, Pendiente, Evaluado), tarjeta |

## Índice de mockups

| Nº | Mockup | Spec | HU |
|---|---|---|---|
| 0001 | [0001-iniciar-sesion.html](0001-iniciar-sesion.html) | [0001-iniciar-sesion.md](../03-specs/0001-iniciar-sesion.md) | HU-01 |
| 0002 | [0002-crear-rubrica.html](0002-crear-rubrica.html) | [0002-crear-rubrica.md](../03-specs/0002-crear-rubrica.md) | HU-11 |
| 0003 | [0003-diligenciar-evaluacion.html](0003-diligenciar-evaluacion.html) | [0003-diligenciar-evaluacion.md](../03-specs/0003-diligenciar-evaluacion.md) | HU-16 |
