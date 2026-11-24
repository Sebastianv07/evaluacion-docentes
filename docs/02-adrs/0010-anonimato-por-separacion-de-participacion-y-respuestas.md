# ADR-0010: Garantizar el anonimato separando la participación del estudiante de sus respuestas

| Campo | Valor |
|---|---|
| Estado | Propuesto |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack; a validar con el Product Owner y el área jurídica |
| Supersede a | — |

## Contexto

Hay dos requisitos que tiran en direcciones opuestas:

1. **Saber quién evaluó:** el estudiante evalúa **una sola vez** por docente, asignatura y periodo, y el docente queda marcado como evaluado para ese estudiante (CU.0003, HU-16 CA4). Además, una evaluación enviada solo se modifica **con autorización del administrador**.
2. **No saber quién respondió qué:** el docente ve resultados consolidados **sin identificar al estudiante** (CU.0003, HU-16 CA6), y son datos personales regulados por la Ley 1581 de 2012.

Si el anonimato depende solo de permisos, cualquier persona con acceso a la base de datos (o un error de permisos) puede unir estudiante y respuestas.

## Decisión

El anonimato se garantiza **por diseño de datos**, no solo por permisos:

- **Participación**: estudiante, asignación (docente–asignatura–grupo), periodo, estado (*pendiente*, *borrador*, *enviada*). Sirve para saber si ya evaluó.
- **Respuesta**: asignación, periodo, calificaciones por ítem, comentario y nota. **No tiene referencia al estudiante** ni fecha y hora exacta de envío (para que no se pueda cruzar con la bitácora).
- Mientras está en **borrador**, las respuestas viven ligadas a la participación. Al **enviar**, en una sola transacción: se crea la Respuesta anónima, se borra el borrador y la participación pasa a *enviada*.
- El **comprobante** entrega al estudiante un código aleatorio; la Respuesta guarda solo el hash de ese código. Para una modificación autorizada, el estudiante presenta su código: **la llave para reidentificar la tiene el estudiante, no el sistema**.
- La bitácora registra que el estudiante *envió* una evaluación, nunca su contenido.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Una sola tabla con el estudiante y las respuestas, protegida por permisos | El anonimato depende de que nadie con acceso a la base consulte la tabla. No resiste una auditoría. |
| Guardar un hash de la cédula en la respuesta | Las cédulas son un conjunto conocido: se puede recalcular el hash de todas y reidentificar. |
| Cifrar la referencia al estudiante | La llave la tiene el sistema; un administrador podría descifrar. |

## Consecuencias

**Positivas**
- Ni el docente, ni el coordinador, ni un administrador de base de datos pueden saber qué respondió un estudiante.
- Evidencia defendible ante una auditoría de la Ley 1581 (fortalece el moat de confianza de la [Strategy](../01-strategy/strategy.md)).

**Negativas / trade-offs**
- Si el estudiante pierde su comprobante, su evaluación **no se puede modificar**; solo se puede dejar como está.
- En grupos muy pequeños el consolidado puede permitir inferir quién respondió. **Pendiente:** definir con el Product Owner un mínimo de respuestas para publicar resultados por grupo.
- El modelo de datos es más complejo que una sola tabla.

## Enlaces

- Spec: [0003-diligenciar-evaluacion.md](../03-specs/0003-diligenciar-evaluacion.md).
- [ADR-0004](0004-azure-sql-database-y-ef-core.md).
