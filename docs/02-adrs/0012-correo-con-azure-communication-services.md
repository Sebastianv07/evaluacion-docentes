# ADR-0012: Comprar el envío de correo a Azure Communication Services en lugar de construirlo

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El sistema envía correos de recuperación de contraseña (HU-02), avisos de apertura de periodo, comprobantes de evaluación (HU-18) y avisos de publicación de resultados.
- Los envíos se concentran en la apertura y el cierre del periodo (miles de estudiantes).
- El presupuesto (Actividad 3) incluye un "servicio de correo transaccional" por $240.000 COP para 3 meses.
- Los correos deben llegar a la bandeja de entrada, no al spam.

## Decisión

El componente **Notificaciones** envía todos los correos a través de **Azure Communication Services (Email)**, con un dominio verificado de la institución. No se construye ni se opera un servidor de correo propio.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Servidor SMTP propio | Hay que operarlo y cuidar la reputación del dominio para no caer en spam. |
| Buzón institucional (Exchange Online / SMTP de Microsoft 365) | Tiene límites de envío diario pensados para personas, no para envíos masivos al cierre del periodo. |
| SendGrid u otro proveedor externo | Viable (era la idea del presupuesto), pero agrega otra cuenta y otro contrato fuera de Azure. |

## Consecuencias

**Positivas**
- Se integra con Key Vault e identidad administrada como el resto de servicios ([ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md)).
- Pago por uso; reemplaza la línea de "correo transaccional" del presupuesto.

**Negativas / trade-offs**
- Requiere que la institución **verifique su dominio** (registros DNS) para enviar desde una dirección institucional.
- Hay límites de envío por defecto que se deben ampliar con una solicitud a Azure antes del primer cierre de periodo.

## Enlaces

- [ADR-0009](0009-autenticacion-local-con-cedula.md), [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md).
- Specs: [0001-iniciar-sesion.md](../03-specs/0001-iniciar-sesion.md), [0003-diligenciar-evaluacion.md](../03-specs/0003-diligenciar-evaluacion.md).
