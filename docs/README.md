# Documentación — Sistema de Evaluación de Docentes

Documentación del proyecto organizada en cuatro artefactos, **de lo general a lo detallado**:

| Carpeta | Artefacto | Capa | Pregunta que responde | Horizonte | Cambia cuando… |
|---|---|---|---|---|---|
| [01-strategy/](01-strategy/) | Strategy | Negocio | ¿Por qué ganamos y defendemos? | Años | cambia la estrategia o el contexto de la institución |
| [02-adrs/](02-adrs/) | ADR | Arquitectura | ¿Por qué decidimos así? | Permanente (inmutable) | otra decisión lo supersede |
| [03-specs/](03-specs/) | Specs | Detalle | ¿Qué y cómo, al detalle? | Por funcionalidad | cambia el alcance o el comportamiento |
| [04-mockups/](04-mockups/) | Mockups | Visual / UI | ¿Cómo se ve y se navega? | Por pantalla | cambia el diseño o la UX |

> **En una frase:** la Strategy fija el rumbo, el ADR decide, la Spec detalla y el Mockup lo hace visible. Lo construido retroalimenta la estrategia y genera nuevos ADR.

## Estructura

```text
docs/
├─ 01-strategy/
│   strategy.md · vision.md · template.md
├─ 02-adrs/            (consecutivos, globales, inmutables)
│   0001-monolito-modular-por-epicas.md … 0014-actualizar-a-net-10-lts.md · template.md
├─ 03-specs/           (una por feature)
│   0001-iniciar-sesion.md
│   0002-crear-rubrica.md
│   0003-diligenciar-evaluacion.md · template.md
└─ 04-mockups/         (HTML autocontenido y navegable · mismo nº que su spec)
    0001-iniciar-sesion.html
    0002-crear-rubrica.html
    0003-diligenciar-evaluacion.html · template.md
```

## Convenciones

- **Carpetas numeradas** 01 → 04, de lo general a lo detallado.
- **02-adrs/**: `NNNN-titulo.md`, consecutivo global. Un ADR **no se edita**: si una decisión cambia, se crea un ADR nuevo y el anterior se marca *Superado por ADR-NNNN*. Nunca se borra.
- **03-specs/**: `NNNN-feature.md`. Una spec sin criterios de aceptación no está lista. Cada spec referencia los ADR que la fundamentan.
- **04-mockups/**: `NNNN-feature.html` con el **mismo número** que su spec. Se abre directamente en el navegador, sin dependencias externas.
- Cada carpeta tiene su `template.md`. Cada PR enlaza el `.md` (spec o ADR) que implementa.

## Índice de ADR

| ADR | Decisión | Estado |
|---|---|---|
| [0001](02-adrs/0001-monolito-modular-por-epicas.md) | Monolito modular con un componente por épica | Aceptado |
| [0002](02-adrs/0002-spa-react-y-api-rest.md) | SPA en React + API REST/JSON sobre HTTPS | Aceptado |
| [0003](02-adrs/0003-backend-aspnet-core-net8.md) | Backend en ASP.NET Core sobre .NET 8 | Superado por 0014 |
| [0004](02-adrs/0004-azure-sql-database-y-ef-core.md) | Azure SQL Database, acceso solo vía EF Core | Aceptado |
| [0005](02-adrs/0005-nube-microsoft-azure.md) | Alojar en Microsoft Azure | Aceptado |
| [0006](02-adrs/0006-region-east-us-2.md) | Región East US 2 | Aceptado (condicionado a jurídica) |
| [0007](02-adrs/0007-topologia-paas-con-front-door.md) | Topología PaaS con Front Door como única entrada | Aceptado |
| [0008](02-adrs/0008-sincronizacion-nocturna-con-plataforma-academica.md) | Sincronización programada con la plataforma académica | Aceptado |
| [0009](02-adrs/0009-autenticacion-local-con-cedula.md) | Autenticación local con cédula y contraseña | Propuesto |
| [0010](02-adrs/0010-anonimato-por-separacion-de-participacion-y-respuestas.md) | Anonimato por separación de participación y respuestas | Propuesto |
| [0011](02-adrs/0011-secretos-en-key-vault-y-endpoints-privados.md) | Key Vault con identidad administrada y endpoints privados | Aceptado |
| [0012](02-adrs/0012-correo-con-azure-communication-services.md) | Correo con Azure Communication Services (*buy*) | Aceptado |
| [0013](02-adrs/0013-reportes-pdf-generados-en-servidor.md) | PDF generados en el servidor y guardados en Blob | Propuesto |
| [0014](02-adrs/0014-actualizar-a-net-10-lts.md) | .NET 10 LTS en lugar de .NET 8 | Propuesto |

*Aceptado* = decisión ya tomada en la Actividad 4. *Propuesto* = decisión nueva derivada de los requisitos, pendiente de validar.

## Qué va en cada artefacto (y qué no)

| Artefacto | Va aquí | **No** va aquí |
|---|---|---|
| Strategy | Tesis de defensibilidad, tipos de defensibilidad + evidencia, segmento y propuesta de valor, amenazas y métricas | Decisiones técnicas (→ ADR) o requisitos (→ Specs) |
| ADR | Stack tecnológico, diseño del sistema, motor de BD, estilo de API, autenticación, topología de despliegue, *build vs buy* | El detalle de una pantalla o feature (→ Specs) |
| Specs | Requisitos funcionales y reglas, datos y contratos de la feature, flujos, estados, casos borde, no funcionales y criterios de aceptación | La arquitectura (→ ADR) o lo visual (→ Mockup) |
| Mockups | Layout y jerarquía visual, navegación, estados (vacío / carga / error / éxito), componentes, responsive y accesibilidad | La lógica ni los contratos de datos (→ Specs) |

## Trazabilidad con las entregas anteriores

| Entrega anterior | Dónde quedó |
|---|---|
| Actividad 2 — Problema, necesidades, alcance, actores | `01-strategy/` (problema y valor) y sección *Alcance* de cada spec |
| Actividad 2 — CU.0001, CU.0002, CU.0003 | `03-specs/0001`, `0002`, `0003` |
| Actividad 3 — Épicas EP-01…EP-07, HU y criterios de aceptación | Specs (criterios Dado/Cuando/Entonces) y ADR-0001 (un componente por épica) |
| Actividad 3 — Estimación y presupuesto (818 h, $89.214.568 COP) | `01-strategy/strategy.md` (evidencia de costo) |
| Actividad 4 — Prototipos HU-01 y HU-16, guía de estilos Figma | `04-mockups/0001` y `0003` |
| Actividad 4 — Diagramas de componentes y despliegue en Azure | ADR-0001 a ADR-0012 |
