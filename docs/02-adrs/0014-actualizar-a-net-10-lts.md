# ADR-0014: Construir el backend sobre .NET 10 (LTS) en lugar de .NET 8

| Campo | Valor |
|---|---|
| Estado | Propuesto |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | [ADR-0003](0003-backend-aspnet-core-net8.md) |

## Contexto

- [ADR-0003](0003-backend-aspnet-core-net8.md) eligió ASP.NET Core sobre **.NET 8**, tal como aparece en el diagrama de despliegue de la Actividad 4.
- **.NET 8 terminó su soporte LTS el 10 de noviembre de 2026**: ya no recibe parches de seguridad.
- El sistema maneja datos personales y credenciales ([ADR-0009](0009-autenticacion-local-con-cedula.md)); no puede salir a producción sin parches.
- **.NET 10** es la versión LTS vigente (publicada en noviembre de 2025, soporte hasta noviembre de 2028).

## Decisión

El backend se construye en **ASP.NET Core sobre .NET 10 (LTS)**. Se mantiene todo lo demás de [ADR-0003](0003-backend-aspnet-core-net8.md): ASP.NET Core y Entity Framework Core.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Mantener .NET 8 | Sin soporte de seguridad desde noviembre de 2026. |
| Usar la versión STS más reciente | Soporte más corto; obligaría a migrar otra vez antes de terminar el primer año en producción. |

## Consecuencias

**Positivas**
- Soporte de seguridad hasta noviembre de 2028, cubriendo los primeros periodos en producción.
- Como el proyecto aún no tiene código, el cambio no cuesta migración.

**Negativas / trade-offs**
- Hay que actualizar el diagrama de despliegue (artefacto `api-evaluacion (.NET 10)`) y la plantilla del pipeline.
- Antes de noviembre de 2028 hará falta un nuevo ADR para la siguiente versión LTS.

## Enlaces

- Supersede a [ADR-0003](0003-backend-aspnet-core-net8.md).
- Diagrama de despliegue: Actividad 4, Figura 6.
