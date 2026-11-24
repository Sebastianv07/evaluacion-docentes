# ADR-0002: Separar el frontend como SPA en React que consume una API REST/JSON sobre HTTPS

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El sistema debe usarse desde un **navegador web estándar** (necesidad de la Actividad 2), en computador o celular.
- Hay cuatro roles (Estudiante, Docente, Directivo/Coordinador, Administrador) con menús y pantallas distintas.
- Las pantallas tienen interacción rica: calificar 1–5 por ítem, avance y nota parcial en vivo, guardar borrador (HU-16, HU-17, HU-19).
- Los reportes son fijos; los reportes dinámicos a la medida están **fuera del alcance**.

## Decisión

- El frontend es una **aplicación de una sola página (SPA) en React**, compilada a archivos estáticos.
- La SPA se comunica con el backend **solo** por una **API REST con JSON sobre HTTPS**. No tiene acceso directo a la base de datos ni a otros servicios.
- La API es la única que aplica reglas de negocio y permisos; la SPA solo oculta opciones por rol como ayuda de usabilidad, no como control de seguridad.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Páginas renderizadas en el servidor (Razor Pages / MVC) | Más simple al inicio, pero acopla la interfaz al backend y hace más pesada la interacción en el formulario de evaluación. |
| API GraphQL | Su ventaja son las consultas flexibles; aquí los reportes son fijos y los reportes a la medida están fuera del alcance. Agrega complejidad sin beneficio. |
| Aplicación móvil nativa | El requisito es navegador estándar; duplicaría el esfuerzo. |

## Consecuencias

**Positivas**
- Frontend y backend se despliegan por separado (ver [ADR-0007](0007-topologia-paas-con-front-door.md)).
- El contrato REST queda documentado en cada spec y se puede probar sin interfaz.
- El mismo contrato sirve a una futura app móvil o a integraciones.

**Negativas / trade-offs**
- Hay que mantener dos proyectos y versionar el contrato de la API.
- Toda validación de la SPA se repite en la API (la de la SPA es solo para usabilidad).
- Requiere manejar CORS o servir ambos bajo el mismo dominio (lo resuelve Front Door).

## Enlaces

- [ADR-0001](0001-monolito-modular-por-epicas.md), [ADR-0007](0007-topologia-paas-con-front-door.md).
- Specs con contratos REST: [0001](../03-specs/0001-iniciar-sesion.md), [0002](../03-specs/0002-crear-rubrica.md), [0003](../03-specs/0003-diligenciar-evaluacion.md).
