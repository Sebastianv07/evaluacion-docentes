# ADR-0005: Alojar la solución en Microsoft Azure

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto, desarrolladores y Product Owner |
| Supersede a | — |

## Contexto

- El presupuesto (Actividad 3) incluye un **servidor en la nube** para pruebas y producción, con la opción de usar un servidor propio de la institución.
- La historia HU-27 se llamó originalmente "Publicar la aplicación en el servidor institucional".
- La institución, como la mayoría de instituciones educativas, ya trabaja con Microsoft (correo, Teams, cuentas institucionales).
- El backend es .NET ([ADR-0003](0003-backend-aspnet-core-net8.md) / [ADR-0014](0014-actualizar-a-net-10-lts.md)).
- El equipo no tiene capacidad para administrar servidores.

## Decisión

La solución se aloja en **Microsoft Azure**, usando servicios administrados (PaaS). La región se define en [ADR-0006](0006-region-east-us-2.md) y la topología en [ADR-0007](0007-topologia-paas-con-front-door.md).

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Servidor institucional (on-premise) | La institución tendría que operar el servidor, sus parches, copias y alta disponibilidad para el pico de cierre. Era la opción original de HU-27. |
| Amazon Web Services | Equivalente en servicios, pero sin la afinidad con las cuentas y herramientas Microsoft de la institución ni con .NET. |
| Google Cloud | Mismas razones que AWS; menor afinidad con el ecosistema de la institución. |

## Consecuencias

**Positivas**
- Integración natural con el ecosistema Microsoft de la institución (y una futura integración con sus cuentas, ver [ADR-0009](0009-autenticacion-local-con-cedula.md)).
- Créditos gratuitos para estudiantes, útiles para el ambiente de pruebas.
- El costo del servidor queda cubierto por la línea "Servidor en la nube" del presupuesto.

**Negativas / trade-offs**
- Dependencia de un proveedor de nube.
- **HU-27 debe renombrarse** a "Publicar la aplicación en Azure" para reflejar esta decisión (pendiente en Jira).

## Enlaces

- Presupuesto: Actividad 3, sección 2.4.
- [ADR-0006](0006-region-east-us-2.md), [ADR-0007](0007-topologia-paas-con-front-door.md).
