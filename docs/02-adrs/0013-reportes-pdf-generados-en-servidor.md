# ADR-0013: Generar los PDF en el servidor y guardarlos en Blob Storage

| Campo | Valor |
|---|---|
| Estado | Propuesto |
| Fecha | 2026-11-23 |
| Decisores | Líder de proyecto y desarrolladores Full Stack |
| Supersede a | — |

## Contexto

- El módulo de reportes debe generar informes **en PDF** e imprimir resultados consolidados por docente, periodo, asignatura o dependencia (HU-21 a HU-23).
- Al enviar una evaluación se genera un **comprobante** (HU-18).
- Los reportes sirven como evidencia institucional (registro calificado, acreditación): deben verse igual sin importar quién los genere ni con qué navegador.
- Los reportes dinámicos a la medida del usuario están **fuera del alcance**.

## Decisión

- El módulo **Reportes de desempeño** genera los PDF **en el backend**, con plantillas fijas, usando una librería .NET de generación de PDF (la librería concreta se elige en un *spike* del sprint 5, revisando su licencia).
- Los PDF generados (reportes y comprobantes) se guardan en **Azure Blob Storage**; la API los entrega al usuario autorizado. Blob Storage no se expone a internet ([ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md)).

## Alternativas consideradas

| Alternativa | Por qué no |
|---|---|
| Imprimir a PDF desde el navegador | El resultado cambia según el navegador; no queda copia oficial guardada. |
| Herramienta de BI externa (Power BI, SSRS) | Orientada a reportes dinámicos (fuera del alcance), con licencias adicionales no presupuestadas. |

## Consecuencias

**Positivas**
- Formato único y estable; el PDF guardado es la versión oficial del reporte de ese momento.
- Los reportes de periodos cerrados no se recalculan cada vez.

**Negativas / trade-offs**
- Generar muchos reportes al cierre consume CPU en la API; si afecta a los estudiantes que evalúan, habrá que mover la generación a un proceso en segundo plano (nuevo ADR).
- Hay que definir cuánto tiempo se guardan los PDF (política de retención con el Product Owner).

## Enlaces

- [ADR-0001](0001-monolito-modular-por-epicas.md), [ADR-0011](0011-secretos-en-key-vault-y-endpoints-privados.md).
- Spec: [0003-diligenciar-evaluacion.md](../03-specs/0003-diligenciar-evaluacion.md) (comprobante).
