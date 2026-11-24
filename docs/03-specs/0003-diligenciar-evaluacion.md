# Spec 0003: Diligenciar y enviar la evaluación de un docente

| Campo | Valor |
|---|---|
| Estado | En revisión |
| Historia(s) de usuario | HU-16 (dispara HU-17 guardar borrador, HU-18 comprobante y HU-19 nota) |
| Caso de uso | CU.0003 – Aplicar evaluación docente |
| Épica | EP-04 – Aplicación de evaluaciones |
| Prioridad / Talla | Alta / L – 24 h |
| Mockup | [0003-diligenciar-evaluacion.html](../04-mockups/0003-diligenciar-evaluacion.html) |
| ADR relacionados | [ADR-0001](../02-adrs/0001-monolito-modular-por-epicas.md), [ADR-0004](../02-adrs/0004-azure-sql-database-y-ef-core.md), [ADR-0010](../02-adrs/0010-anonimato-por-separacion-de-participacion-y-respuestas.md), [ADR-0012](../02-adrs/0012-correo-con-azure-communication-services.md), [ADR-0013](../02-adrs/0013-reportes-pdf-generados-en-servidor.md) |

## 1. Resumen / objetivo

Permitir que el **estudiante** califique a un docente de una de sus asignaturas con la **rúbrica vigente** del periodo y envíe la evaluación. Al enviar, el sistema calcula la nota, guarda la evaluación **de forma anónima**, marca al docente como evaluado para ese estudiante y genera el comprobante.

## 2. Alcance

**Dentro:**
- Formulario con la ficha del docente, la rúbrica vigente agrupada por criterios y la escala 1–5 por ítem.
- Comentario opcional para el docente.
- Avance y nota parcial mientras se diligencia.
- Guardar como borrador desde el formulario (acción de HU-17).
- Validación de ítems obligatorios, cálculo de la nota (HU-19), envío y comprobante (HU-18).
- Bloqueo cuando el periodo está cerrado o el docente ya fue evaluado.

**Fuera:**
- Listado de evaluaciones pendientes (HU-15).
- Consulta de resultados por parte del docente (HU-20).
- Modificación de una evaluación ya enviada con autorización del administrador.
- Consolidación y reportes (EP-05).

## 3. Requisitos

### 3.1 Funcionales

| ID | Requisito |
|---|---|
| RF-1 | El formulario solo se abre si el estudiante está **matriculado** en la asignatura del docente, el **periodo está abierto** y hay una **rúbrica vigente**. |
| RF-2 | El formulario muestra docente, asignatura, grupo, periodo con su **fecha de cierre** y la rúbrica vigente con cada criterio y su **ponderación**. |
| RF-3 | Cada ítem se califica con un valor entero de **1 a 5**. Los obligatorios se identifican como tales. |
| RF-4 | El comentario para el docente es **opcional**. |
| RF-5 | Mientras diligencia, el estudiante ve el **avance** (ítems calificados / total) y la **nota parcial** (ver fórmula en §4.3). |
| RF-6 | «Guardar borrador» guarda lo diligenciado para retomarlo antes del cierre del periodo. |
| RF-7 | «Finalizar y enviar» valida que **todos los ítems obligatorios** estén calificados. Si falta alguno, indica **cuáles** y no envía. |
| RF-8 | Al enviar con datos completos: calcula la nota definitiva, guarda la evaluación, marca al docente como **evaluado** para ese estudiante y genera el **comprobante**. |
| RF-9 | Se permite **una sola evaluación** por estudiante, docente, asignatura y periodo. |
| RF-10 | Una evaluación enviada **no se puede modificar** desde esta pantalla. |
| RF-11 | Se envía al estudiante el comprobante por correo. |

### 3.2 No funcionales

| ID | Tipo | Requisito |
|---|---|---|
| RNF-1 | Privacidad | La respuesta enviada **no queda asociada al estudiante** ([ADR-0010](../02-adrs/0010-anonimato-por-separacion-de-participacion-y-respuestas.md)). Los identificadores de las respuestas son aleatorios (no secuenciales) para que no se puedan correlacionar por orden. |
| RNF-2 | Privacidad | La bitácora registra que el estudiante envió una evaluación, **nunca** su contenido. |
| RNF-3 | Integridad | El envío es **atómico**: se crea la respuesta, se borra el borrador y la participación pasa a *enviada* en una sola transacción. |
| RNF-4 | Integridad | La unicidad de RF-9 se garantiza con una restricción en la base de datos ([ADR-0004](../02-adrs/0004-azure-sql-database-y-ef-core.md)). |
| RNF-5 | Rendimiento | Enviar la evaluación ≤ 2 s en el percentil 95, también durante el pico del cierre del periodo. |
| RNF-6 | Accesibilidad | La escala 1–5 se puede operar solo con teclado; los ítems faltantes se anuncian a lectores de pantalla. |

## 4. Datos y contratos

### 4.1 Datos

| Entidad | Campos relevantes |
|---|---|
| Participacion | `estudianteId`, `asignacionId` (docente–asignatura–grupo), `periodoId`, `estado` (`Pendiente` · `Borrador` · `Enviada` · `CerradaSinEnviar`), `enviadaEn`. Único por (`estudianteId`, `asignacionId`, `periodoId`). |
| Borrador | `participacionId`, `calificaciones` (ítem → valor), `comentario`, `actualizadoEn`. Se borra al enviar. |
| Respuesta | `id` (aleatorio), `asignacionId`, `periodoId`, `rubricaId`, `calificaciones`, `comentario`, `nota`, `hashCodigoComprobante`. **Sin** `estudianteId` ni fecha y hora de envío. |

### 4.2 API

**`GET /api/evaluaciones/{asignacionId}/formulario`**

```json
{
  "docente": { "nombre": "Carlos Restrepo Mejía" },
  "asignatura": "Bases de Datos II", "grupo": "03",
  "periodo": { "id": "2026-2", "estado": "Abierto", "fechaCierre": "2026-11-28" },
  "rubrica": { "id": "…", "nombre": "Evaluación docente 2026-2",
    "criterios": [ { "id": "c1", "nombre": "Dominio del tema", "ponderacion": 30,
      "items": [ { "id": "i1", "texto": "Explica los temas con claridad y seguridad", "obligatorio": true } ] } ] },
  "borrador": { "calificaciones": { "i1": 4 }, "comentario": "" }
}
```

**`PUT /api/evaluaciones/{asignacionId}/borrador`** — `{ "calificaciones": { "i1": 4 }, "comentario": "…" }` → **204**.

**`POST /api/evaluaciones/{asignacionId}/envio`** — mismo cuerpo → **201** `{ "codigoComprobante": "ED-7Q4M-92KX", "nota": 3.9, "urlComprobante": "/api/comprobantes/ED-7Q4M-92KX" }`.

| Código | `codigo` | Cuándo (aplica a los tres endpoints) |
|---|---|---|
| 403 | `NO_HABILITADO` | El estudiante no está matriculado en la asignatura del docente. |
| 409 | `YA_EVALUADO` | La participación ya está *enviada*. |
| 422 | `ITEMS_OBLIGATORIOS_FALTANTES` | Solo en el envío. Incluye `itemIds: ["i4"]`. |
| 422 | `VALOR_FUERA_DE_ESCALA` | Alguna calificación no es un entero de 1 a 5. |
| 423 | `PERIODO_CERRADO` | El periodo de evaluación ya cerró. |

### 4.3 Cálculo de la nota (HU-19)

```text
promedio(c) = promedio de los ítems calificados del criterio c
nota        = Σ ( ponderacion(c) / 100 × promedio(c) )   sobre los criterios con al menos un ítem calificado
```

Resultado en escala 1–5, redondeado a **1 decimal** para mostrar (se guarda con 2 decimales). La **nota parcial** usa la misma fórmula con los ítems calificados hasta el momento.

*Ejemplo (el del mockup):* Dominio 30 % → (4 + 5) / 2 = 4,5; Metodología 40 % → 4; Evaluación 30 % → 3.
Nota = 0,30 × 4,5 + 0,40 × 4 + 0,30 × 3 = **3,85 ≈ 3,9**.

## 5. Flujos y estados

**Flujo principal (CU.0003, secuencia normal):**
Evaluaciones pendientes → seleccionar docente → formulario con rúbrica vigente → calificar ítems (+ comentario opcional) → «Finalizar y enviar» → validar obligatorios → calcular nota, guardar respuesta anónima, marcar docente evaluado, generar comprobante → confirmación con código de comprobante.

**Flujo alternativo (borrador):** «Guardar borrador» → confirmación → el estudiante sale → vuelve desde Evaluaciones pendientes antes del cierre → continúa en el paso de calificar.

**Flujos de error:** ítems obligatorios faltantes → se señalan y se bloquea el envío; periodo cerrado → no se permite diligenciar ni enviar.

**Estados de la participación:**

| Estado | Entra cuando | Sale a |
|---|---|---|
| Pendiente | El estudiante queda habilitado (HU-09) | Borrador · Enviada · CerradaSinEnviar |
| Borrador | Guarda borrador | Borrador · Enviada · CerradaSinEnviar |
| Enviada | Envío exitoso | — (final) |
| CerradaSinEnviar | El periodo cierra sin envío; el borrador se descarta | — (final) |

## 6. Casos borde

| # | Situación | Comportamiento esperado |
|---|---|---|
| 1 | El periodo cierra mientras el estudiante está diligenciando | Al enviar o guardar: 423 `PERIODO_CERRADO`; se informa que el periodo cerró. |
| 2 | Doble clic en «Finalizar y enviar» o dos pestañas abiertas | Solo se crea una respuesta; el segundo intento recibe 409 `YA_EVALUADO`. |
| 3 | El estudiante se retiró de la asignatura (sincronización nocturna) mientras tenía un borrador | 403 `NO_HABILITADO`; el borrador se descarta. |
| 4 | Ítems no obligatorios sin calificar | Se permite enviar; no cuentan en el promedio del criterio. |
| 5 | Un criterio solo tiene ítems no obligatorios y ninguno se calificó | **Pendiente** (§8). Propuesta: el criterio se excluye y las demás ponderaciones se reescalan a 100 %. |
| 6 | Comentario muy largo | Máximo propuesto: 1.000 caracteres; se indica el límite. |
| 7 | Se manipula la solicitud con un valor 0, 6 o decimal | 422 `VALOR_FUERA_DE_ESCALA`. |
| 8 | La rúbrica vigente cambia después de que el estudiante guardó un borrador | Fuera del alcance (HU-12). Supuesto: una rúbrica vigente no se modifica una vez abierto el periodo. |
| 9 | Falla el envío del correo con el comprobante | La evaluación queda enviada igual; el comprobante sigue disponible en «Comprobantes» y el correo se reintenta. |

## 7. Criterios de aceptación

CA1 a CA6 vienen de HU-16. CA7 a CA9 se derivan de esta spec.

| # | Dado | Cuando | Entonces |
|---|---|---|---|
| CA1 | El estudiante tiene un docente pendiente y el periodo de evaluación está abierto | Selecciona al docente en «Evaluaciones pendientes» | El sistema muestra el formulario con la rúbrica vigente. |
| CA2 | El estudiante calificó todos los ítems obligatorios | Da clic en «Finalizar y enviar» | El sistema calcula la nota, guarda la evaluación, marca al docente como evaluado y genera el comprobante. |
| CA3 | Quedó algún ítem obligatorio sin calificar | Da clic en «Finalizar y enviar» | El sistema muestra cuáles faltan y no deja enviar. |
| CA4 | El estudiante ya envió la evaluación de ese docente | Intenta evaluarlo otra vez en el mismo periodo y asignatura | El sistema no se lo permite (una sola evaluación por docente, asignatura y periodo). |
| CA5 | El periodo de evaluación ya cerró | Intenta abrir o enviar el formulario | El sistema muestra que el periodo está cerrado y no deja diligenciar. |
| CA6 | El docente consulta sus resultados | Abre la evaluación consolidada | Ve las notas y comentarios sin el nombre de ningún estudiante. |
| CA7 | El estudiante calificó 4,5 / 4 / 3 en criterios de 30 / 40 / 30 % | Mira la nota parcial | El sistema muestra 3,9 / 5,0. |
| CA8 | El estudiante guardó un borrador | Vuelve antes del cierre del periodo | El formulario aparece con sus calificaciones y comentario guardados. |
| CA9 | Se envió una evaluación | Se revisa la tabla de respuestas en la base de datos | La respuesta no contiene la cédula, el id del estudiante ni la fecha y hora del envío. |

## 8. Riesgos y pendientes

| # | Pendiente | Responsable |
|---|---|---|
| 1 | Regla para criterios sin ítems calificados (caso borde 5). | Product Owner |
| 2 | Mínimo de respuestas por grupo para publicar resultados al docente ([ADR-0010](../02-adrs/0010-anonimato-por-separacion-de-participacion-y-respuestas.md)). | Product Owner + jurídica |
| 3 | Número esperado de estudiantes evaluando a la vez al cierre, para dimensionar el autoescalado. | Product Owner |
| 4 | ¿Se modera el comentario (lenguaje ofensivo, datos personales)? Hoy queda fuera del alcance. | Product Owner |
