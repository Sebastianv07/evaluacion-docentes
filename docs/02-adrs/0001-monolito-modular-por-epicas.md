# ADR-0001: Construir la API como un monolito modular con un componente por épica

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El backlog tiene 7 épicas (EP-01 a EP-07) y 27 historias de usuario, que se construyen en 5 sprints de 2 semanas con **2 desarrolladores**.
- La carga es baja la mayor parte del periodo, con un pico concentrado al cierre de la evaluación.
- Necesitamos que cada historia de usuario tenga un lugar claro en el código para facilitar la trazabilidad HU → código → prueba.
- Varias funcionalidades dependen entre sí: Evaluaciones necesita Rúbricas, Reportes necesita Evaluaciones y todos los módulos registran en la bitácora.

## Decisión

La API es **una sola aplicación desplegable**, organizada internamente en **un componente (módulo) por épica**, con dependencias explícitas y en una sola dirección:

| Componente | Épica / HU |
|---|---|
| Seguridad y acceso | EP-01 · HU-01 a HU-04 |
| Bitácora de auditoría | EP-01 · HU-05 y HU-06 |
| Configuración académica | EP-02 · HU-07 a HU-10 |
| Rúbricas y criterios | EP-03 · HU-11 a HU-14 |
| Evaluaciones | EP-04 · HU-15 a HU-20 |
| Reportes de desempeño | EP-05 · HU-21 a HU-24 |
| Integración académica | EP-06 · HU-25 y HU-26 |
| Notificaciones | EP-01 y EP-04 |
| Acceso a datos | TA-01 |

Dependencias permitidas: Evaluaciones → Rúbricas; Rúbricas → Configuración académica; Reportes → Evaluaciones; Integración académica → Configuración académica; Seguridad y acceso → Notificaciones; todos → Bitácora y Acceso a datos. Un módulo no accede a las tablas de otro: usa su interfaz pública.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Microservicios (un servicio por épica) | Exige despliegues, monitoreo y comunicación entre servicios que 2 desarrolladores no pueden operar en 10 semanas. El volumen de usuarios no lo justifica. |
| Monolito por capas sin módulos (controladores / servicios / repositorios globales) | Se pierde la trazabilidad épica → código y las dependencias entre funcionalidades quedan implícitas. |

## Consecuencias

**Positivas**
- Un solo despliegue y transacciones locales simples (por ejemplo, enviar evaluación + marcar docente evaluado).
- Cada historia de usuario tiene un módulo dueño; el equipo sabe dónde va cada cambio.
- Si un módulo necesita escalar aparte (por ejemplo, Reportes), se puede extraer después porque ya tiene límites claros.

**Negativas / trade-offs**
- Todo escala junto: el pico de cierre escala también los módulos que no lo necesitan.
- Los límites entre módulos dependen de la disciplina del equipo; hay que revisarlos en code review o con pruebas de arquitectura.
- Todos los módulos comparten una base de datos (ver [ADR-0004](0004-azure-sql-database-y-ef-core.md)).

## Enlaces

- Diagrama de componentes: Actividad 4, Figura 5.
- [ADR-0002](0002-spa-react-y-api-rest.md), [ADR-0003](0003-backend-aspnet-core-net8.md), [ADR-0004](0004-azure-sql-database-y-ef-core.md).
