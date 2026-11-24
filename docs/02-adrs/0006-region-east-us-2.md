# ADR-0006: Desplegar en la región East US 2 de Azure

| Campo | Valor |
|---|---|
| Estado | Aceptado — **condicionado** al aval del área jurídica (ver Consecuencias) |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y Product Owner |
| Supersede a | — |

## Contexto

- Todos los servicios de [ADR-0007](0007-topologia-paas-con-front-door.md) deben estar disponibles en la región.
- Los usuarios están en Colombia; la latencia debe ser aceptable para un formulario web.
- El presupuesto es ajustado.
- El sistema guarda **datos personales** de estudiantes y docentes, regulados por la **Ley 1581 de 2012**.

## Decisión

Todos los recursos de los ambientes de producción y pruebas se crean en la región **East US 2**.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Brazil South | Más cerca de los usuarios, pero con precios más altos en la mayoría de servicios y sin evitar la transferencia internacional de datos (también está fuera de Colombia). |
| Otra región de EE. UU. (East US, South Central US) | Equivalentes; East US 2 tiene todos los servicios necesarios y buenos precios. |

## Consecuencias

**Positivas**
- Disponibilidad de todos los servicios y menor costo.
- Latencia desde Colombia aceptable para una aplicación web de formularios.

**Negativas / trade-offs**
- **Los datos personales quedan fuera del país.** La institución debe validar con su área jurídica la transferencia internacional de datos según la Ley 1581 de 2012 **antes de salir a producción**. Si no se aprueba, este ADR se supersede por uno que defina otra ubicación.
- La recuperación ante desastres en otra región no está incluida en el presupuesto.

## Enlaces

- [ADR-0005](0005-nube-microsoft-azure.md), [ADR-0007](0007-topologia-paas-con-front-door.md).
- Strategy: amenaza "Transferencia internacional de datos no aprobada" ([strategy.md](../01-strategy/strategy.md)).
