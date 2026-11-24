# Spec 0002: Crear rúbrica con criterios y ponderaciones

| Campo | Valor |
|---|---|
| Estado | En revisión |
| Historia(s) de usuario | HU-11 (incluye la validación de HU-14) |
| Caso de uso | CU.0002 – Gestionar rúbricas y criterios |
| Épica | EP-03 – Rúbricas y criterios |
| Prioridad / Talla | Alta / L – 24 h (+ XS – 4 h de HU-14) |
| Mockup | [0002-crear-rubrica.html](../04-mockups/0002-crear-rubrica.html) |
| ADR relacionados | [ADR-0001](../02-adrs/0001-monolito-modular-por-epicas.md), [ADR-0002](../02-adrs/0002-spa-react-y-api-rest.md), [ADR-0004](../02-adrs/0004-azure-sql-database-y-ef-core.md) |

## 1. Resumen / objetivo

Permitir que el **administrador** cree una rúbrica para un periodo académico, con sus **criterios**, la **ponderación** de cada criterio y los **ítems** que el estudiante calificará de 1 a 5. Es el instrumento con el que se evalúa a los docentes en la [Spec 0003](0003-diligenciar-evaluacion.md).

## 2. Alcance

**Dentro:**
- Listado de rúbricas existentes y acceso a «Nueva rúbrica».
- Formulario con nombre, periodo, criterios, ponderaciones e ítems.
- Validación de campos obligatorios y de que las ponderaciones sumen 100 % (HU-14).
- Guardar, cancelar y registro en la bitácora.

**Fuera:**
- Modificar una rúbrica existente (HU-12) y las reglas sobre rúbricas vigentes con evaluaciones.
- Duplicar una rúbrica de un periodo anterior (HU-13).
- Asignar la rúbrica vigente a un periodo y abrir el periodo (HU-10, proceso BPMN 1).
- Escalas distintas de 1 a 5.

## 3. Requisitos

### 3.1 Funcionales

| ID | Requisito |
|---|---|
| RF-1 | Solo el rol **Administrador** puede crear rúbricas. |
| RF-2 | Una rúbrica tiene **nombre**, **periodo académico** y **uno o más criterios**. |
| RF-3 | Cada criterio tiene **nombre**, **ponderación porcentual** (mayor que 0 y hasta 100) y **uno o más ítems**. |
| RF-4 | Cada ítem tiene **texto** y la marca de **obligatorio** (por defecto, sí). Todos los ítems se califican en una escala fija de **1 a 5**. |
| RF-5 | Al guardar, el sistema valida que **las ponderaciones de los criterios sumen exactamente 100 %**; si no, muestra un error y no guarda. |
| RF-6 | Al guardar, el sistema valida los campos obligatorios (nombre, criterio, ponderación, texto del ítem) y **señala cada campo faltante**; no guarda. |
| RF-7 | Con datos válidos, la rúbrica queda guardada y **disponible** para el periodo, y el sistema muestra un mensaje de confirmación. |
| RF-8 | «Cancelar» descarta los cambios y vuelve al listado de rúbricas. |
| RF-9 | La creación queda en la bitácora con usuario y fecha. |
| RF-10 | Mientras el administrador edita, el sistema muestra la **suma actual** de las ponderaciones. |

### 3.2 No funcionales

| ID | Tipo | Requisito |
|---|---|---|
| RNF-1 | Seguridad | La API rechaza la operación (403) si el usuario no es Administrador, aunque la interfaz no muestre la opción. |
| RNF-2 | Integridad | La validación de suma 100 % y de campos obligatorios se hace **en la API**; la de la interfaz es solo de ayuda. |
| RNF-3 | Integridad | La rúbrica con sus criterios e ítems se guarda en **una sola transacción**: o se guarda completa o no se guarda nada. |
| RNF-4 | Rendimiento | Guardar una rúbrica de hasta 10 criterios y 50 ítems ≤ 2 s. |

## 4. Datos y contratos

### 4.1 Datos

| Entidad | Campos relevantes |
|---|---|
| Rubrica | `id`, `nombre`, `periodoId`, `estado` (`Disponible` · `Vigente` · `Inactiva`), `creadaPor`, `creadaEn` |
| Criterio | `id`, `rubricaId`, `nombre`, `ponderacion` (decimal, 2 decimales), `orden` |
| Item | `id`, `criterioId`, `texto`, `obligatorio`, `orden` |

Restricción: `Σ ponderacion` de los criterios de una rúbrica = **100,00**.

### 4.2 API

**`GET /api/rubricas?periodoId={id}`** → 200 con el listado `[{ id, nombre, periodo, estado, numeroCriterios, creadaEn }]`.

**`POST /api/rubricas`**

```json
{
  "nombre": "Evaluación docente 2026-2",
  "periodoId": "2026-2",
  "criterios": [
    { "nombre": "Dominio del tema", "ponderacion": 30, "orden": 1,
      "items": [ { "texto": "Explica los temas con claridad y seguridad", "obligatorio": true } ] },
    { "nombre": "Metodología", "ponderacion": 40, "orden": 2, "items": [ … ] },
    { "nombre": "Evaluación y retroalimentación", "ponderacion": 30, "orden": 3, "items": [ … ] }
  ]
}
```

| Código | `codigo` | Cuándo |
|---|---|---|
| 201 | — | Rúbrica creada. Devuelve `{ id, estado: "Disponible" }`. |
| 403 | `SIN_PERMISO` | El usuario no es Administrador. |
| 422 | `PONDERACION_NO_SUMA_100` | La suma no es 100. Incluye `sumaActual`. |
| 422 | `CAMPOS_OBLIGATORIOS` | Falta algún dato. Incluye `campos: ["criterios[1].ponderacion", …]`. |
| 409 | `NOMBRE_DUPLICADO` | Ya existe una rúbrica con ese nombre en el periodo. |

## 5. Flujos y estados

**Flujo principal (CU.0002, secuencia normal):**
Menú → «Gestión de rúbricas» → listado → «Nueva rúbrica» → formulario → el administrador ingresa datos y ponderaciones → «Guardar» → validación → se guarda, se registra en la bitácora y se confirma → listado con la nueva rúbrica.

**Flujos alternativos:** «Cancelar» → descarta y vuelve al listado.

**Estados de la pantalla:**

| Estado | Descripción |
|---|---|
| Listado vacío | No hay rúbricas en el periodo: se invita a crear la primera. |
| Listado | Rúbricas existentes con su estado. |
| Formulario | Creando la rúbrica; la suma de ponderaciones se ve en vivo. |
| Error de suma | Al guardar, la suma ≠ 100 %. |
| Error de campos | Al guardar, faltan datos; cada campo faltante queda señalado. |
| Guardando | Solicitud en curso; no se permite un segundo envío. |
| Guardada | Confirmación y regreso al listado. |

**Estados de la rúbrica:** `Disponible` (recién creada) → `Vigente` (asignada a un periodo abierto, HU-10) → `Inactiva` (periodo cerrado). Las transiciones a `Vigente` e `Inactiva` están fuera del alcance de esta spec.

## 6. Casos borde

| # | Situación | Comportamiento esperado |
|---|---|---|
| 1 | Ponderaciones con decimales que no cierran: 33,33 + 33,33 + 33,33 = 99,99 | Error de suma: debe ser exactamente 100,00. |
| 2 | Suma mayor a 100 (p. ej., 110) | Error de suma con `sumaActual = 110`. |
| 3 | Un criterio con ponderación 0 o negativa | Error de campo en esa ponderación. |
| 4 | Un criterio sin ítems | Error de campo: cada criterio necesita al menos un ítem. |
| 5 | Un solo criterio con 100 % | Válido. |
| 6 | Todos los ítems de un criterio marcados como no obligatorios | Válido, pero se muestra una advertencia (no bloquea). |
| 7 | Nombre repetido en el mismo periodo | 409 `NOMBRE_DUPLICADO`. |
| 8 | Cancelar con cambios sin guardar | Se descartan sin pedir confirmación (CU.0002, alternativa 2). Ver pendiente 2. |
| 9 | Doble clic en «Guardar» | Se crea una sola rúbrica. |
| 10 | Se pierde la sesión mientras edita | Al guardar, 401; se vuelve al inicio de sesión y se pierden los cambios (ver pendiente 3). |

## 7. Criterios de aceptación

CA1 a CA6 vienen de HU-11. CA7 viene de HU-14. CA8 y CA9 se derivan de los casos borde.

| # | Dado | Cuando | Entonces |
|---|---|---|---|
| CA1 | El administrador inició sesión | Entra a «Gestión de rúbricas» y da clic en «Nueva rúbrica» | El sistema muestra el formulario con nombre, periodo, criterios y ponderación. |
| CA2 | El administrador llenó todos los campos y los porcentajes suman 100 % | Da clic en «Guardar» | La rúbrica queda guardada, disponible para el periodo, y el sistema muestra un mensaje de confirmación. |
| CA3 | Los porcentajes de los criterios no suman 100 % | Da clic en «Guardar» | El sistema muestra un mensaje de error y no deja guardar. |
| CA4 | Falta un campo obligatorio (nombre, criterio o ponderación) | Da clic en «Guardar» | El sistema señala en rojo los campos faltantes y no deja guardar. |
| CA5 | El administrador está creando la rúbrica | Da clic en «Cancelar» | El sistema descarta los cambios y vuelve al listado de rúbricas. |
| CA6 | La rúbrica se guardó | Se revisa la bitácora | Aparece el registro de la creación con el usuario y la fecha. |
| CA7 | El administrador cambia una ponderación | Mira el total | El sistema muestra la suma actual y si llega o no al 100 %. |
| CA8 | Un usuario que no es Administrador | Llama directamente a la API de creación | La API responde 403 y no crea nada. |
| CA9 | Las ponderaciones son 33,33 + 33,33 + 33,33 | Da clic en «Guardar» | El sistema muestra el error de suma (99,99 %) y no guarda. |

## 8. Riesgos y pendientes

| # | Pendiente | Responsable |
|---|---|---|
| 1 | ¿Se permiten ponderaciones con decimales o solo enteros? (Propuesta: hasta 2 decimales.) | Product Owner |
| 2 | ¿Se pide confirmación al cancelar con cambios sin guardar? CU.0002 dice que se descartan; se sugiere confirmar. | Product Owner |
| 3 | ¿Guardado automático para no perder una rúbrica larga si vence la sesión? | Equipo / Product Owner |
| 4 | Definir el núcleo de criterios estables entre periodos (ver Strategy, plan para profundizar, punto 1). | Vicerrectoría Académica |
