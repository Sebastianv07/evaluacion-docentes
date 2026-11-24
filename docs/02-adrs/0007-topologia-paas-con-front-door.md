# ADR-0007: Usar una topología PaaS con Azure Front Door como única puerta de entrada

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El equipo es pequeño y no puede administrar máquinas virtuales (parches, copias, sistema operativo).
- Hay un **pico de carga** cuando muchos estudiantes evalúan al cierre del periodo.
- El acceso debe ser solo por HTTPS y con restricciones de seguridad institucionales (CU.0001).
- El presupuesto contempla dos ambientes: producción y pruebas.

## Decisión

Topología basada en servicios administrados:

| Servicio | Rol en la topología |
|---|---|
| **Azure Front Door** (con WAF) | Única entrada pública: dominio, certificado TLS, firewall web. Enruta `/` al frontend y `/api` a la API. |
| **Azure Static Web Apps** | Aloja la SPA compilada ([ADR-0002](0002-spa-react-y-api-rest.md)). |
| **Azure App Service (Linux)** | Ejecuta la API con **2 instancias mínimas y autoescalado** para el pico de cierre. |
| **Azure Functions** | Ejecuta la sincronización programada ([ADR-0008](0008-sincronizacion-nocturna-con-plataforma-academica.md)). |
| **Application Insights** | Errores, tiempos de respuesta y disponibilidad. |
| **GitHub Actions** | CI/CD: publica automáticamente cada versión aprobada. |

Dos ambientes con la misma estructura: **rg-evaldocente-prod** y **rg-evaldocente-qa** (planes más pequeños).

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Máquinas virtuales (IaaS) | El equipo tendría que administrar sistema operativo, parches y copias. |
| Contenedores en AKS | Potente pero excesivo para un monolito modular con un equipo de 2 desarrolladores. |
| Servir SPA y API desde el mismo App Service, sin Front Door | Más simple, pero sin WAF, sin un punto único de entrada y con el App Service expuesto directamente a internet. |

## Consecuencias

**Positivas**
- Azure administra servidores, parches, certificados y escalado.
- Un solo dominio para SPA y API: no hay problemas de CORS.
- La infraestructura de pruebas replica la de producción.

**Negativas / trade-offs**
- El App Service y Static Web Apps deben **aceptar tráfico solo desde Front Door** (restricción por etiqueta de servicio y encabezado de Front Door); si no, el WAF se puede saltar.
- Las reglas administradas del WAF requieren el nivel Premium de Front Door, más costoso que el Standard.
- Más servicios que configurar y monitorear que un solo servidor.

## Enlaces

- Diagrama de despliegue: Actividad 4, Figura 6.
- [ADR-0005](0005-nube-microsoft-azure.md), [ADR-0006](0006-region-east-us-2.md), [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md).
