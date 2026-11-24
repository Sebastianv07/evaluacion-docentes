# Spec 0001: Iniciar sesión con cédula y contraseña

| Campo | Valor |
|---|---|
| Estado | En revisión |
| Historia(s) de usuario | HU-01 (incluye el inicio de la recuperación de HU-02, por el CA4 de HU-01) |
| Caso de uso | CU.0001 – Inicio de sesión |
| Épica | EP-01 – Acceso y seguridad |
| Prioridad / Talla | Alta / M – 16 h |
| Mockup | [0001-iniciar-sesion.html](../04-mockups/0001-iniciar-sesion.html) |
| ADR relacionados | [ADR-0002](../02-adrs/0002-spa-react-y-api-rest.md), [ADR-0009](../02-adrs/0009-autenticacion-local-con-cedula.md), [ADR-0011](../02-adrs/0011-secretos-en-key-vault-y-endpoints-privados.md), [ADR-0012](../02-adrs/0012-correo-con-azure-communication-services.md) |

## 1. Resumen / objetivo

Permitir que un usuario de la institución (Estudiante, Docente, Directivo/Coordinador o Administrador) entre al sistema con su **cédula** y su **contraseña**, y llegue al menú principal **solo con las opciones de su rol**. Cada acceso queda registrado en la bitácora.

## 2. Alcance

**Dentro:**
- Formulario de inicio de sesión con cédula y contraseña.
- Validación de credenciales, rol y permisos.
- Registro del acceso en la bitácora.
- Solicitud de recuperación de contraseña por correo institucional y definición de la nueva contraseña con sus reglas.

**Fuera:**
- Creación de usuarios y asignación de roles (HU-03).
- Configuración de permisos por rol (HU-04).
- Inicio de sesión único con cuentas institucionales (descartado por ahora en [ADR-0009](../02-adrs/0009-autenticacion-local-con-cedula.md)).
- Cambio de contraseña desde el perfil del usuario ya autenticado.

## 3. Requisitos

### 3.1 Funcionales

| ID | Requisito |
|---|---|
| RF-1 | El usuario es siempre el **número de cédula**: solo dígitos, sin puntos ni espacios. |
| RF-2 | La contraseña se captura **enmascarada**; el usuario puede mostrarla temporalmente para revisarla. |
| RF-3 | Con credenciales válidas y usuario activo, el sistema autentica, valida rol y permisos y lleva al **menú principal del rol**. |
| RF-4 | Con credenciales inválidas (o usuario inactivo), el sistema muestra **«Usuario o contraseña inválidos»** y no da acceso. El mensaje es el mismo en ambos casos. |
| RF-5 | «¿Olvidaste tu contraseña?» pide el **correo institucional** y envía un **enlace temporal de un solo uso** para definir una nueva contraseña. |
| RF-6 | La nueva contraseña debe tener **letras, números y al menos un signo**. Si no cumple, se rechaza y se explican las reglas. |
| RF-7 | Al restablecer la contraseña, el sistema vuelve al formulario de inicio de sesión (paso 2 de la secuencia normal de CU.0001). |
| RF-8 | Cada inicio de sesión exitoso se registra en la bitácora con **fecha, hora y usuario**. |

### 3.2 No funcionales

| ID | Tipo | Requisito |
|---|---|---|
| RNF-1 | Seguridad | Solo HTTPS. La contraseña se guarda únicamente como hash ([ADR-0009](../02-adrs/0009-autenticacion-local-con-cedula.md)). |
| RNF-2 | Seguridad | El sistema **no revela si una cédula o un correo existen**: mismo mensaje y mismo tiempo de respuesta aproximado en todos los casos de error. |
| RNF-3 | Seguridad | Bloqueo temporal tras intentos fallidos consecutivos (valor propuesto: 5 intentos → 15 minutos; ver pendientes). |
| RNF-4 | Seguridad | El token de sesión es de corta duración; los permisos se validan en la API en cada solicitud. |
| RNF-5 | Rendimiento | Respuesta del inicio de sesión ≤ 2 s en el percentil 95. |
| RNF-6 | Auditoría | Los intentos fallidos también se registran en la bitácora (sin guardar la contraseña escrita). |
| RNF-7 | Accesibilidad | Los errores se anuncian a lectores de pantalla y se asocian a su campo (el detalle visual está en el mockup). |

## 4. Datos y contratos

### 4.1 Datos

| Entidad | Campos relevantes |
|---|---|
| Usuario | `cedula` (único), `nombre`, `correoInstitucional` (único), `rol` (Estudiante · Docente · Coordinador · Administrador), `activo`, `hashContrasena`, `intentosFallidos`, `bloqueadoHasta` |
| TokenRecuperacion | `usuarioId`, `hashToken`, `expiraEn`, `usadoEn` |
| EventoBitacora | `usuario`, `accion` (`LOGIN_OK`, `LOGIN_FALLIDO`, `RECUPERACION_SOLICITADA`, `CONTRASENA_RESTABLECIDA`), `fechaHora`, `ip` |

### 4.2 API

**`POST /api/auth/login`**

```json
// Solicitud
{ "cedula": "1036458921", "contrasena": "********" }

// 200 OK
{
  "accessToken": "<token>",
  "expiraEnSegundos": 3600,
  "usuario": { "cedula": "1036458921", "nombre": "Laura Gómez", "rol": "Estudiante", "permisos": ["evaluaciones.diligenciar", "comprobantes.ver"] }
}
```

| Código | `codigo` del error | Cuándo |
|---|---|---|
| 400 | `DATOS_INVALIDOS` | Cédula vacía o con caracteres que no son dígitos; contraseña vacía. |
| 401 | `CREDENCIALES_INVALIDAS` | Cédula o contraseña incorrectas, o usuario inactivo. Mensaje: «Usuario o contraseña inválidos». |
| 423 | `CUENTA_BLOQUEADA` | Se superó el número de intentos fallidos. |

**`POST /api/auth/recuperacion`** — `{ "correoInstitucional": "lgomez@correo.itm.edu.co" }` → **202 Accepted** siempre (exista o no el correo).

**`POST /api/auth/restablecimiento`** — `{ "token": "<token>", "nuevaContrasena": "********" }`

| Código | `codigo` | Cuándo |
|---|---|---|
| 204 | — | Contraseña actualizada; el token queda usado. |
| 400 | `CONTRASENA_NO_CUMPLE` | No tiene letras, números y al menos un signo. Incluye `reglas: [...]` incumplidas. |
| 410 | `TOKEN_EXPIRADO_O_USADO` | El enlace venció o ya se usó. |

## 5. Flujos y estados

**Flujo principal (CU.0001, secuencia normal):**
Abrir la aplicación → formulario → ingresar cédula y contraseña → «Iniciar sesión» → la API verifica credenciales → valida rol y permisos → registra en bitácora → menú principal del rol.

**Flujo alternativo (recuperación):**
«¿Olvidaste tu contraseña?» → ingresar correo institucional → mensaje de confirmación genérico → el usuario abre el enlace del correo → define nueva contraseña válida → vuelve al formulario de inicio de sesión.

**Estados del formulario:**

| Estado | Entra cuando | Sale a |
|---|---|---|
| Inicial | Se abre la aplicación sin sesión | Enviando |
| Enviando | Clic en «Iniciar sesión» con datos completos | Éxito · Error de credenciales · Cuenta bloqueada |
| Error de credenciales | 401 | Enviando (nuevo intento) |
| Cuenta bloqueada | 423 | Inicial (al vencer el bloqueo) |
| Éxito | 200 | Menú principal del rol |
| Recuperación solicitada | 202 | Inicial |

## 6. Casos borde

| # | Situación | Comportamiento esperado |
|---|---|---|
| 1 | Cédula escrita con puntos o espacios (`1.036.458.921`) | Se rechaza en el formulario: «Solo números, sin puntos ni espacios». La API también responde 400 si llega así. |
| 2 | Usuario existe pero está **inactivo** | Mismo mensaje que credenciales inválidas (RNF-2). |
| 3 | Correo de recuperación **no registrado** | Misma respuesta 202 y mismo mensaje en pantalla. No se envía correo. |
| 4 | El enlace de recuperación se usa dos veces o después de vencer | 410; se ofrece solicitar un enlace nuevo. |
| 5 | Se solicitan varios enlaces seguidos | Solo el último enlace es válido. |
| 6 | Doble clic en «Iniciar sesión» | Se envía una sola solicitud (botón deshabilitado mientras está Enviando). |
| 7 | Usuario con más de un rol (p. ej., docente que también es estudiante de posgrado) | **Pendiente** (ver §8). Propuesta: el sistema pide escoger el rol después de autenticar. |
| 8 | Contraseña con espacios al inicio o al final | Se respetan tal cual; no se recortan. |
| 9 | El token de sesión vence mientras el usuario trabaja | La API responde 401 y la aplicación vuelve al inicio de sesión. |

## 7. Criterios de aceptación

CA1 a CA6 vienen de HU-01. CA7 a CA9 se derivan de los casos borde de esta spec.

| # | Dado | Cuando | Entonces |
|---|---|---|---|
| CA1 | El usuario existe y está activo en la base de datos | Ingresa su cédula y su contraseña correctas y da clic en «Iniciar sesión» | El sistema lo deja entrar al menú principal solo con las opciones de su rol. |
| CA2 | El usuario está en el formulario de inicio de sesión | Escribe la contraseña | Los caracteres se ven enmascarados (••••). |
| CA3 | El usuario ingresa una cédula o contraseña incorrecta | Da clic en «Iniciar sesión» | El sistema muestra «Usuario o contraseña inválidos» y no le da acceso. |
| CA4 | El usuario olvidó su contraseña | Selecciona «Recuperar contraseña» y escribe su correo institucional | El sistema le envía un enlace temporal para definir una nueva contraseña. |
| CA5 | El usuario define una nueva contraseña | La contraseña no tiene letras, números y al menos un signo | El sistema no la acepta y le explica las reglas. |
| CA6 | El usuario inicia sesión correctamente | Entra al menú principal | El sistema guarda el acceso en la bitácora con fecha, hora y usuario. |
| CA7 | El usuario existe pero está inactivo | Ingresa sus credenciales correctas | El sistema muestra «Usuario o contraseña inválidos», igual que en CA3. |
| CA8 | Se escribe un correo que no está registrado | Se solicita la recuperación | Se muestra el mismo mensaje de confirmación que con un correo válido y no se envía ningún correo. |
| CA9 | Un enlace de recuperación ya se usó o venció | El usuario lo abre | El sistema indica que el enlace no es válido y ofrece pedir uno nuevo. |

## 8. Riesgos y pendientes

| # | Pendiente | Responsable |
|---|---|---|
| 1 | Confirmar longitud mínima de la contraseña (propuesta: 8 caracteres) y qué caracteres cuentan como "signo". | Product Owner + seguridad institucional |
| 2 | Confirmar política de bloqueo por intentos fallidos (propuesta: 5 intentos → 15 min). | Product Owner |
| 3 | Duración del enlace de recuperación (propuesta: 30 min). | Product Owner |
| 4 | Cómo se comporta un usuario con más de un rol (caso borde 7). | Product Owner |
| 5 | Validar si la "conexión segura" exige además alguna restricción institucional (p. ej., horarios o redes). | Seguridad institucional |
