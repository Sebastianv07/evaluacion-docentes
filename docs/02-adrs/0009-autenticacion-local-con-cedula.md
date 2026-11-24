# ADR-0009: Autenticación local con cédula y contraseña administrada por la API

| Campo | Valor |
|---|---|
| Estado | Propuesto |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack; a validar con el Product Owner |
| Supersede a | — |

## Contexto

- CU.0001 y HU-01 exigen que el **usuario sea el número de cédula**, que la contraseña tenga **letras, números y al menos un signo**, y que exista **recuperación por correo institucional**.
- Los usuarios se crean a partir de la plataforma institucional ([ADR-0008](0008-sincronizacion-nocturna-con-plataforma-academica.md)).
- Cada acceso debe quedar en la bitácora con fecha, hora y usuario (HU-01 CA6).
- Los permisos dependen del rol (HU-03, HU-04) y se deben aplicar en el servidor.

## Decisión

- La identidad se administra **dentro del sistema** con **ASP.NET Core Identity**: el nombre de usuario es la cédula y la contraseña se guarda solo como hash (nunca en texto plano).
- Al iniciar sesión, la API emite un **token de acceso de corta duración** con el rol del usuario; la API valida rol y permisos en **cada** solicitud.
- La recuperación de contraseña usa un **enlace temporal de un solo uso** enviado al correo institucional ([ADR-0012](0012-correo-con-azure-communication-services.md)).

## Alternativas consideradas

| Alternativa | Por qué no (por ahora) |
|---|---|
| Inicio de sesión único (SSO) con las cuentas institucionales de Microsoft (Entra ID) | Mejor experiencia y sin contraseña adicional, pero contradice el requisito explícito de "usuario = cédula" y no está confirmado que todos los estudiantes tengan cuenta institucional activa. Se recomienda evaluarlo en un ADR futuro. |
| Validar credenciales contra la plataforma académica | Haría que el inicio de sesión dependa de la disponibilidad de un sistema externo (contrario a [ADR-0008](0008-sincronizacion-nocturna-con-plataforma-academica.md)). |
| Proveedor de identidad externo (Auth0, Entra External ID) | Costo adicional no presupuestado para un requisito que el framework ya cubre. |

## Consecuencias

**Positivas**
- Cumple CU.0001 tal como fue especificado.
- El inicio de sesión no depende de sistemas externos.

**Negativas / trade-offs**
- El sistema **custodia credenciales**: aumenta la responsabilidad de seguridad (hash, bloqueo ante intentos repetidos, recuperación segura).
- Los usuarios tienen una contraseña más que recordar.
- Migrar luego a SSO exige un nuevo ADR y un plan de transición.

## Enlaces

- Spec: [0001-iniciar-sesion.md](../03-specs/0001-iniciar-sesion.md).
- [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md), [ADR-0012](0012-correo-con-azure-communication-services.md).
