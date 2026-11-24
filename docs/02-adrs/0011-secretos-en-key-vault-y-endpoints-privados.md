# ADR-0011: Guardar secretos en Key Vault con identidad administrada y aislar los datos con endpoints privados

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El problema original incluye **riesgos de seguridad y control** sobre información confidencial.
- La API y la función de sincronización necesitan cadenas de conexión, credenciales de la plataforma académica y claves del servicio de correo.
- La base de datos y el almacenamiento guardan datos personales (Ley 1581 de 2012).

## Decisión

- **Azure Key Vault** guarda todos los secretos. La API y la Azure Function los leen con **identidad administrada**; ningún secreto queda en el código, en el repositorio ni en las variables del pipeline.
- La base de datos, Blob Storage y Key Vault se exponen **solo por endpoints privados** dentro de una **red virtual (VNet)**; no tienen acceso público desde internet.
- App Service y Azure Functions se integran a la VNet para alcanzar esos servicios.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Secretos en la configuración del App Service o en el repositorio | Quedan visibles para quien tenga acceso al portal o al código; no hay rotación centralizada. |
| Servicios de datos con acceso público y reglas de firewall por IP | Las IP de salida de los servicios PaaS cambian; una regla mal configurada expone los datos a internet. |

## Consecuencias

**Positivas**
- Superficie de ataque mínima: los datos no son alcanzables desde internet.
- Rotación de secretos sin desplegar código.

**Negativas / trade-offs**
- La Azure Function necesita un **plan que soporte integración con VNet** (por ejemplo, Flex Consumption o Premium), más costoso que el plan de consumo básico.
- Los desarrolladores no pueden conectarse directamente a la base de producción desde su equipo; necesitan un acceso controlado (por ejemplo, una VPN o un host de salto).
- Más configuración de red (DNS privado, subredes).

## Enlaces

- Diagrama de despliegue: Actividad 4, Figura 6.
- [ADR-0004](0004-azure-sql-database-y-ef-core.md), [ADR-0007](0007-topologia-paas-con-front-door.md), [ADR-0008](0008-sincronizacion-nocturna-con-plataforma-academica.md).
