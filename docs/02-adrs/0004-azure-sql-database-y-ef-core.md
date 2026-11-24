# ADR-0004: Usar Azure SQL Database como motor de base de datos, con acceso solo a través de EF Core

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- Los datos son claramente relacionales: periodos → asignaturas → grupos → matrículas; rúbricas → criterios → ítems; evaluaciones por docente, asignatura y periodo.
- Hay reglas que deben garantizarse en la base de datos y no solo en el código: **una sola evaluación por estudiante, docente, asignatura y periodo** (CU.0003) y ponderaciones que suman 100 % (HU-14).
- Los reportes consolidan por docente, periodo, asignatura y dependencia (HU-21 a HU-24): consultas de agregación.
- El sistema guarda histórico de varios años y requiere copias de seguridad automáticas.

## Decisión

- El motor es **Azure SQL Database** (servicio administrado), una base por ambiente.
- El componente **Acceso a datos** (EF Core) es la **única capa** que lee y escribe en la base de datos; los demás módulos no ejecutan SQL directo.
- Las reglas de unicidad críticas se implementan también como **restricciones de la base de datos** (índices únicos), no solo como validaciones de la API.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Azure Database for PostgreSQL | Técnicamente equivalente; se prefiere SQL Server por la integración con .NET/EF Core y la experiencia del equipo. |
| Base NoSQL (Azure Cosmos DB) | El modelo es relacional y necesita transacciones y restricciones de unicidad entre entidades; los reportes de agregación son más naturales en SQL. |
| SQL Server en máquina virtual | El equipo tendría que administrar parches y copias de seguridad (ver [ADR-0007](0007-topologia-paas-con-front-door.md)). |

## Consecuencias

**Positivas**
- Copias de seguridad automáticas y restauración a un punto en el tiempo sin trabajo del equipo.
- Las reglas críticas no dependen de que la API no tenga errores.
- Migraciones de esquema versionadas junto al código (EF Core Migrations).

**Negativas / trade-offs**
- Una sola base compartida por todos los módulos: un cambio de esquema puede afectar a varios ([ADR-0001](0001-monolito-modular-por-epicas.md)).
- Dependencia del proveedor (Azure SQL). Mitigado porque EF Core permite cambiar de motor con esfuerzo moderado.

## Enlaces

- [ADR-0001](0001-monolito-modular-por-epicas.md), [ADR-0010](0010-anonimato-por-separacion-de-participacion-y-respuestas.md), [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md).
- Diagramas de componentes y despliegue: Actividad 4, Figuras 5 y 6.
