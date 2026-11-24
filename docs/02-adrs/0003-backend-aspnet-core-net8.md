# ADR-0003: Construir el backend en ASP.NET Core sobre .NET 8

| Campo | Valor |
|---|---|
| Estado | **Superado por [ADR-0014](0014-actualizar-a-net-10-lts.md)** |
| Fecha | 2026-11-23 (registra la decisión tomada en la Actividad 4) |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

> Este ADR no se edita. Se conserva para dejar trazable la decisión original. La versión de .NET la define ahora [ADR-0014](0014-actualizar-a-net-10-lts.md).

## Contexto

- Se necesita un backend que exponga la API REST ([ADR-0002](0002-spa-react-y-api-rest.md)) y contenga los módulos por épica ([ADR-0001](0001-monolito-modular-por-epicas.md)).
- La institución trabaja con el ecosistema Microsoft (correo, Teams, cuentas institucionales).
- Se requiere un ORM maduro para una base de datos relacional y buena integración con la nube elegida.

## Decisión

El backend se construye en **ASP.NET Core sobre .NET 8**, con Entity Framework Core como ORM.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Node.js (NestJS) | Viable, pero con menos afinidad con el ecosistema Microsoft de la institución y con Azure. |
| Java (Spring Boot) | Viable, pero mayor consumo de recursos en planes pequeños de App Service y menos experiencia del equipo. |

## Consecuencias

**Positivas**
- Despliegue sencillo en Azure App Service y uso de identidad administrada.
- EF Core, ASP.NET Core Identity y Application Insights disponibles de forma nativa.

**Negativas / trade-offs**
- **.NET 8 terminó su soporte LTS el 10 de noviembre de 2026.** Desplegar a producción sobre una versión sin parches de seguridad no es aceptable → se supersede con [ADR-0014](0014-actualizar-a-net-10-lts.md).

## Enlaces

- Diagrama de despliegue: Actividad 4, Figura 6 (artefacto `api-evaluacion (.NET 8)`).
- [ADR-0014](0014-actualizar-a-net-10-lts.md).
