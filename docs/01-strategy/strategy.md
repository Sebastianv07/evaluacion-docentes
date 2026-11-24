# Strategy — Sistema de Evaluación de Docentes

> **Pregunta que responde:** ¿por qué esta solución gana hoy frente a las alternativas de la institución y por qué se sigue sosteniendo en los próximos años?
> **No va aquí:** decisiones técnicas (→ [02-adrs/](../02-adrs/)) ni requisitos o features (→ [03-specs/](../03-specs/)).

| Campo | Valor |
|---|---|
| Versión | 1.0 |
| Fecha de revisión | 2026-11-23 |
| Próxima revisión | Al cierre del primer periodo evaluado en el sistema, y luego una vez al año |
| Responsable | Product Owner (Vicerrectoría Académica) con el líder del proyecto |
| Visión | [vision.md](vision.md) |

## 1. Resumen ejecutivo

La institución no necesita "una encuesta más": necesita **evidencia confiable y acumulada** sobre cómo enseñan sus docentes. La solución gana porque es la única alternativa que reúne tres cosas a la vez: **sabe quién puede evaluar a quién** (por estar conectada a las matrículas reales), **protege al estudiante** (anonimato y trazabilidad exigidos por la Ley 1581 de 2012) y **acumula un histórico comparable** periodo tras periodo.

Se mantiene en el tiempo porque ese histórico y esa configuración institucional crecen con cada periodo: entre más periodos se evalúan en el sistema, más costoso es volver a las hojas de cálculo o reemplazarlo por otra herramienta que empiece desde cero.

## 2. Mercado y problema

**Cliente / segmento.** Institución de educación superior pública con varias sedes y facultades, que evalúa a sus docentes cada periodo académico. El patrocinador es la Vicerrectoría Académica; los usuarios son estudiantes, docentes, coordinadores/directivos y administradores.

**Problema.** Hoy la evaluación se hace de forma manual o con herramientas sueltas (hojas de cálculo y formularios desconectados). Eso produce:

| Problema | Consecuencia para el negocio |
|---|---|
| Falta de trazabilidad histórica | No hay forma de ver la evolución de un docente entre periodos. |
| Demoras en la retroalimentación | Los resultados llegan tarde y el docente no alcanza a mejorar en el siguiente periodo. |
| Problemas de escalabilidad | Cada nueva facultad o sede multiplica el trabajo manual. |
| Riesgos de seguridad y control | Datos confidenciales y personales sin control estricto de roles y permisos. |

**Alternativas actuales de la institución.**

| Alternativa | Por qué no resuelve el problema |
|---|---|
| Seguir con hojas de cálculo y formularios | Es el origen del problema: no hay histórico, no se sabe quién está habilitado para evaluar y la tabulación es manual. |
| Formularios genéricos (Microsoft Forms, Google Forms) | Son gratis y fáciles de usar, pero no conocen las matrículas, no garantizan una sola evaluación por docente, asignatura y periodo, y no consolidan por dependencia. |
| Módulo de la plataforma académica existente | Depende de la hoja de ruta del proveedor de la plataforma; hoy no cubre rúbricas ponderadas ni reportes por dependencia. |

**Propuesta de valor.** Un proceso evaluativo único, centralizado y auditable que entrega a la institución resultados consolidados al cierre de cada periodo, y al docente retroalimentación anónima y comparable en el tiempo.

## 3. Defensibilidad: tipos + evidencia

De los tipos de *moat* (red, costos de cambio, escala, marca, datos, plataforma, regulación), aplican cuatro. Los otros tres se descartan explícitamente para no sobrevender la estrategia.

| Tipo de moat | Tesis | Evidencia (cómo se mide y prueba) | Estado |
|---|---|---|---|
| **Datos** | Cada periodo suma resultados al histórico del docente. Una herramienta nueva empieza sin pasado; el sistema ya tiene la serie histórica. | % de docentes con resultados en 2 o más periodos; número de periodos consolidados en el sistema. | Hipótesis — se empieza a medir al cerrar el 2.º periodo. |
| **Costos de cambio** | Las rúbricas configuradas, el calendario de evaluación, los usuarios capacitados y los reportes que ya usan las decanaturas hacen costoso volver atrás. | N.º de periodos seguidos sin hojas de cálculo paralelas; n.º de dependencias que usan los reportes en sus comités. | Hipótesis — se mide desde el 1.er periodo. |
| **Plataforma (integración)** | Solo el sistema conoce las matrículas reales, así que solo aquí "el estudiante evalúa a sus docentes, una vez" es una garantía y no una promesa. | % de estudiantes habilitados automáticamente sin corrección manual; n.º de evaluaciones duplicadas o de estudiantes no matriculados (meta: 0). | Hipótesis — se mide en el periodo piloto. |
| **Regulación y confianza** | Ley 1581 de 2012, anonimato del estudiante y bitácora de auditoría. Una alternativa informal no puede demostrar quién vio qué y cuándo; el sistema sí. Esa evidencia sirve para registro calificado y acreditación. | N.º de incidentes de exposición de identidad (meta: 0); auditorías internas aprobadas; uso de los reportes como evidencia en procesos de registro calificado o acreditación. | Hipótesis — se mide anualmente. |
| Red | No aplica: el valor para un usuario no crece porque haya más usuarios en otras instituciones. | — | Descartado |
| Escala | No aplica: es un sistema de una institución; el costo por usuario no es una ventaja frente a las alternativas. | — | Descartado |
| Marca | No aplica: es una herramienta interna. | — | Descartado |

**Evidencia de costo disponible hoy.** La inversión estimada es de **$89.214.568 COP con IVA** (818 horas, 5 sprints de 2 semanas). Esa inversión es baja frente al costo recurrente de tabular a mano cada periodo, pero la comparación queda **por demostrar** midiendo las horas que hoy dedica la institución a tabular (línea base pendiente con el Product Owner).

> Una ventaja sin evidencia es solo una hipótesis. Hoy todas las tesis de esta tabla son hipótesis; la sección 6 define cómo convertirlas en evidencia.

## 4. Amenazas y erosión

| Amenaza | Qué moat erosiona | Señal de alerta |
|---|---|---|
| El proveedor de la plataforma académica lanza su propio módulo de evaluación docente | Plataforma (integración) | Anuncio en la hoja de ruta del proveedor; la institución pide comparar. |
| Formularios gratuitos "suficientemente buenos" vuelven a usarse en paralelo | Costos de cambio | Aparecen hojas de cálculo paralelas en alguna facultad. |
| Baja participación estudiantil | Datos | Participación por debajo de la meta: los resultados dejan de ser representativos y pierden peso en decisiones. |
| Pérdida de confianza en el anonimato (una filtración o la percepción de que el docente puede identificar al estudiante) | Regulación y confianza; Datos | Caída de participación o de comentarios abiertos entre periodos; quejas formales. |
| Cambios de rúbrica sin continuidad entre periodos | Datos | Criterios no comparables entre periodos: el histórico se fragmenta. |
| Rechazo docente (percibe la evaluación como punitiva) | Costos de cambio | Reclamaciones sobre los resultados; los coordinadores dejan de usar los reportes. |
| Transferencia internacional de datos personales no aprobada por el área jurídica | Regulación y confianza | Observaciones de jurídica sobre la Ley 1581 de 2012. |

## 5. Plan para profundizar

Acciones de negocio para hacer más profundo el foso (no son features):

1. **Proteger la comparabilidad del histórico.** Acordar con la Vicerrectoría un núcleo de criterios estables entre periodos; los cambios de rúbrica se hacen sobre ese núcleo y no lo reemplazan.
2. **Convertir los reportes en evidencia oficial.** Lograr que los reportes del sistema sean la fuente aceptada de desempeño docente para comités, registro calificado y acreditación.
3. **Cerrar el ciclo con el estudiante.** Comunicar cada periodo qué se mejoró gracias a la evaluación; eso sostiene la participación, que es la materia prima del moat de datos.
4. **Hacer visible la confianza.** Publicar la política de anonimato y tratamiento de datos, y presentar cada año el resultado de la auditoría de accesos.
5. **Eliminar las herramientas paralelas.** Cada facultad que entra al sistema deja de usar hojas de cálculo; la meta es cero procesos paralelos al segundo periodo.
6. **Asegurar el aval jurídico** sobre el tratamiento y la ubicación de los datos personales antes del primer periodo en producción.

## 6. Métricas de defensibilidad

Las metas son **propuestas a validar con el Product Owner**; la línea base se toma en el primer periodo.

| Métrica | Qué demuestra (moat) | Línea base | Meta propuesta | Frecuencia |
|---|---|---|---|---|
| Tasa de participación estudiantil (evaluaciones enviadas / evaluaciones habilitadas) | Datos | Por medir (1.er periodo) | Crecer cada periodo hasta ≥ 70 % | Por periodo |
| Días entre el cierre del periodo y la publicación de resultados al docente | Valor frente al proceso manual | Por medir (proceso actual) | ≤ 10 días hábiles | Por periodo |
| % de docentes con histórico de 2 o más periodos | Datos | 0 % | ≥ 80 % al cerrar el 2.º periodo | Por periodo |
| Retención: periodos seguidos sin hojas de cálculo paralelas | Costos de cambio | 0 | Todos los periodos desde el 2.º | Por periodo |
| N.º de dependencias que usan los reportes en sus comités | Costos de cambio | 0 | Todas las facultades al año 1 | Semestral |
| Incidentes de exposición de identidad del estudiante | Regulación y confianza | 0 | 0 | Continua |
| NPS de docentes y coordinadores | Costos de cambio; confianza | Por medir | ≥ 30 | Anual |
| Horas de tabulación manual evitadas por periodo | Valor económico | Por medir (proceso actual) | ≥ 90 % de reducción | Por periodo |

> **LTV/CAC y cuota de mercado** no aplican mientras el sistema sea de uso interno de una sola institución. Se agregarían solo si se decide ofrecerlo a otras instituciones, lo cual hoy está **fuera del alcance**.

## Historial de revisiones

| Fecha | Cambio |
|---|---|
| 2026-11-23 | Versión inicial a partir de las actividades 2, 3 y 4 del proyecto. |
