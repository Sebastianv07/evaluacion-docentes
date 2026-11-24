# ADR-0008: Integrar con la plataforma académica por sincronización programada, no por consultas en línea

| Campo | Valor |
|---|---|
| Estado | Aceptado |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El sistema necesita usuarios, asignaturas, grupos y matrículas de la plataforma académica institucional (HU-25, HU-26) para habilitar a cada estudiante a evaluar solo a sus docentes (HU-09, CU.0003).
- La plataforma es un **sistema externo** que no controlamos; su disponibilidad y su capacidad son desconocidas.
- Las historias de integración son las de mayor riesgo del backlog (talla XL).
- El pico de uso del sistema coincide con el cierre del periodo.

## Decisión

- El sistema mantiene **su propia copia** de usuarios, asignaturas y matrículas.
- Una **Azure Function programada** sincroniza **cada noche** contra la API HTTPS de la plataforma académica, insertando o actualizando registros.
- Además, la sincronización se ejecuta **al abrir el periodo de evaluación** (proceso BPMN 1), para habilitar a los estudiantes con datos al día.
- Si la plataforma no responde, el sistema sigue funcionando con la última copia y registra el fallo en la bitácora y en Application Insights.

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Consultar la plataforma en línea en cada operación | Si la plataforma se cae, nadie puede evaluar; además le trasladamos nuestro pico de carga. |
| Integración por eventos (la plataforma notifica cambios) | Depende de que la plataforma soporte webhooks o eventos; no está confirmado. |
| Carga manual de archivos CSV | Propensa a errores y contraria al objetivo de eliminar procesos manuales. Se deja solo como contingencia. |

## Consecuencias

**Positivas**
- El sistema no depende de la disponibilidad de la plataforma durante la evaluación.
- La carga sobre la plataforma es predecible (una vez por noche).

**Negativas / trade-offs**
- Los datos pueden tener **hasta 24 horas de retraso**: un estudiante matriculado hoy aparece mañana.
- Hay que manejar **retiros y cancelaciones** (un estudiante que se retira de una asignatura debe quedar inhabilitado sin borrar evaluaciones ya enviadas).
- Requiere conocer el contrato de la API de la plataforma; es el principal riesgo técnico y se ataca primero (sprint 3).

## Enlaces

- BPMN Proceso 1: Actividad 4, Figura 3.
- [ADR-0007](0007-topologia-paas-con-front-door.md), [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md).
