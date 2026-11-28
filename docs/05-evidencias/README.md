# Evidencias

Evidencias de que los mockups cumplen lo especificado: capturas de **todos los estados**, vista móvil, **pruebas funcionales automáticas** contra los criterios de aceptación y trazabilidad.

| Evidencia | Archivo |
|---|---|
| 📄 PDF para la entrega | [Proyecto - Evaluacion Docentes - Evidencias.pdf](../../entrega/Proyecto%20-%20Evaluacion%20Docentes%20-%20Evidencias.pdf) |
| 🧪 Pruebas funcionales (ejecutables) | [pruebas-mockups.html](pruebas-mockups.html) |
| 🖼️ Capturas (28) | [capturas/](capturas/) |
| ⚙️ Script que lo regenera todo | [generar-evidencias.sh](generar-evidencias.sh) |
| 🧾 Fuente del PDF | [informe-evidencias.html](informe-evidencias.html) |

---

## 1. Pruebas funcionales: 27 de 27 pasan

Cada prueba abre el mockup, simula la acción del usuario (escribir, hacer clic, enviar) y comprueba el resultado contra el criterio de aceptación de la spec. Se ejecutaron con Chrome en modo headless el 27/11/2026.

![Resultados de las pruebas](capturas/pruebas-resultados.png)

| # | Prueba | Criterio | Resultado |
|---|---|---|---|
| | **Mockup 0001 · Iniciar sesión** | | |
| 1 | La contraseña se muestra enmascarada al cargar | CA2 | ✅ |
| 2 | «Mostrar» revela la contraseña y «Ocultar» la vuelve a enmascarar | CA2 | ✅ |
| 3 | Una cédula con puntos se rechaza con un mensaje en el campo | RF-1 · caso borde 1 | ✅ |
| 4 | Credenciales incorrectas: «Usuario o contraseña inválidos» y no da acceso | CA3 | ✅ |
| 5 | Credenciales correctas: llega a la pantalla de éxito con acceso registrado | CA1 · CA6 | ✅ |
| 6 | Cuenta bloqueada: el botón queda deshabilitado | RNF-3 | ✅ |
| 7 | «¿Olvidaste tu contraseña?» pide el correo y confirma con un mensaje genérico | CA4 · CA8 | ✅ |
| 8 | Una contraseña nueva sin signo se rechaza y explica las reglas | CA5 | ✅ |
| | **Mockup 0002 · Crear rúbrica** | | |
| 9 | «Nueva rúbrica» abre el formulario con nombre, periodo, criterios y ponderación | CA1 | ✅ |
| 10 | El total de ponderaciones se recalcula en vivo al escribir | CA7 | ✅ |
| 11 | Si las ponderaciones suman 90 %, muestra el error y no guarda | CA3 · HU-14 | ✅ |
| 12 | 33,33 + 33,33 + 33,33 = 99,99 % no se acepta | CA9 | ✅ |
| 13 | Sin nombre, señala el campo faltante en rojo y no guarda | CA4 | ✅ |
| 14 | Sin una ponderación, marca ese campo y no guarda | CA4 | ✅ |
| 15 | Con datos completos y 100 %, guarda y confirma en el listado | CA2 | ✅ |
| 16 | «Cancelar» descarta los cambios y vuelve al listado | CA5 | ✅ |
| 17 | «+ Agregar criterio» y «+ Agregar ítem» agregan filas | RF-2 · RF-3 | ✅ |
| | **Mockup 0003 · Diligenciar evaluación** | | |
| 18 | Muestra la rúbrica vigente con los criterios y su peso (30/40/30) | CA1 | ✅ |
| 19 | Avance y nota parcial: 4 de 5 ítems (80 %) y nota 3,9 | CA7 · §4.3 | ✅ |
| 20 | Enviar con un ítem obligatorio vacío: señala cuál falta y no envía | CA3 | ✅ |
| 21 | Al calificar el ítem faltante, el error desaparece | Notas de interacción | ✅ |
| 22 | «Guardar borrador» confirma y marca al docente como Borrador | RF-6 · HU-17 | ✅ |
| 23 | Enviar completo: calcula la nota, marca Evaluado y genera el comprobante | CA2 | ✅ |
| 24 | La nota sigue la fórmula ponderada: todo en 5 → 5,0; todo en 1 → 1,0 | HU-19 · §4.3 | ✅ |
| 25 | Ya evaluado: no muestra el formulario e informa la regla de una sola evaluación | CA4 | ✅ |
| 26 | Periodo cerrado: el formulario queda bloqueado | CA5 | ✅ |
| 27 | El aviso de anonimato está siempre visible | CA6 (interfaz) | ✅ |

**Trazabilidad de los 27 criterios de aceptación:** 19 verificados en los mockups, 2 verificados parcialmente (solo la parte visible) y 6 que dependen del backend (bitácora real, respuesta 403 de la API, persistencia del borrador, contenido de la base de datos) y se verifican en la implementación. El detalle está en la sección 7 del PDF.

---

## 2. Mockup 0001 · Iniciar sesión (HU-01)

| | |
|:---:|:---:|
| ![](capturas/0001-inicial.png)<br>**Inicial (vacío)** | ![](capturas/0001-cargando.png)<br>**Validando (carga)** |
| ![](capturas/0001-cedula-invalida.png)<br>**Cédula con formato inválido** | ![](capturas/0001-error.png)<br>**Credenciales inválidas — CA3** |
| ![](capturas/0001-bloqueada.png)<br>**Cuenta bloqueada** | ![](capturas/0001-exito.png)<br>**Ingreso exitoso — CA1, CA6** |
| ![](capturas/0001-recuperar.png)<br>**Solicitar enlace — CA4** | ![](capturas/0001-enviado.png)<br>**Enlace enviado, mensaje genérico — CA8** |
| ![](capturas/0001-restablecer.png)<br>**Nueva contraseña sin signo — CA5** | |

## 3. Mockup 0002 · Crear rúbrica (HU-11, HU-14)

| | |
|:---:|:---:|
| ![](capturas/0002-listado-vacio.png)<br>**Listado vacío** | ![](capturas/0002-listado.png)<br>**Listado con rúbricas** |
| ![](capturas/0002-formulario.png)<br>**Formulario — CA1** | ![](capturas/0002-error-suma.png)<br>**No suma 100 % — CA3, CA7** |
| ![](capturas/0002-error-campos.png)<br>**Campos faltantes — CA4** | ![](capturas/0002-guardando.png)<br>**Guardando (carga)** |
| ![](capturas/0002-guardada.png)<br>**Guardada — CA2** | |

## 4. Mockup 0003 · Diligenciar evaluación (HU-16)

| | |
|:---:|:---:|
| ![](capturas/0003-cargando.png)<br>**Cargando** | ![](capturas/0003-diligenciando.png)<br>**Diligenciando: 80 % y nota 3,9 — CA1, CA7** |
| ![](capturas/0003-error-obligatorio.png)<br>**Ítem obligatorio sin calificar — CA3** | ![](capturas/0003-borrador.png)<br>**Borrador guardado** |
| ![](capturas/0003-enviando.png)<br>**Enviando (carga)** | ![](capturas/0003-enviada.png)<br>**Enviada con comprobante — CA2** |
| ![](capturas/0003-periodo-cerrado.png)<br>**Periodo cerrado — CA5** | ![](capturas/0003-ya-evaluado.png)<br>**Ya evaluado — CA4** |

## 5. Vista móvil (390 px)

Cada mockup se cargó dentro de un marco real de 390 px (un celular): sin desplazamiento horizontal, menú en barra horizontal y escala 1–5 con opciones de 44 × 44 px.

| Inicio de sesión | Crear rúbrica | Evaluación | Evaluación (página completa) |
|:---:|:---:|:---:|:---:|
| ![](capturas/movil-0001-error.png) | ![](capturas/movil-0002-error-suma.png) | ![](capturas/movil-0003-error-obligatorio.png) | ![](capturas/movil-0003-pagina-completa.png) |

---

## 6. Defectos encontrados y corregidos

| # | Defecto | Cómo se encontró | Corrección |
|---|---|---|---|
| 1 | En la alerta de 0002, el título y el texto salían pegados («90 %Deben sumar…»). | Revisión de la captura de escritorio. | El título pasa a su propia línea. |
| 2 | La nota podía mostrarse como 3,8 en vez de 3,9 por imprecisión de punto flotante al redondear 3,85. | Revisión del cálculo antes de la prueba 19. | Redondeo explícito a un decimal; la prueba 19 confirma 3,9. |
| 3 | Al validar campos vacíos en 0002, la ponderación vacía no quedaba marcada en rojo. | Revisión del flujo de error. | Se marcan todos los campos vacíos; lo confirma la prueba 14. |

> Las primeras capturas móviles salieron cortadas. No era un defecto del diseño: Chrome en Windows no abre ventanas de menos de ~500 px. Por eso la vista móvil se mide dentro de un marco real de 390 px.

## 7. Verificaciones adicionales

| Verificación | Resultado |
|---|---|
| Enlaces internos de toda la documentación | ✅ 0 rotos |
| Sintaxis del JavaScript de los 3 mockups | ✅ 3 de 3 |
| Mockups autocontenidos (sin dependencias externas) | ✅ Cumple |
| Mismo número entre spec y mockup | ✅ 0001, 0002, 0003 |
| Plantilla en cada carpeta de documentación | ✅ 4 de 4 |

## 8. Cómo reproducirlas

Desde la raíz del repositorio (Git Bash en Windows, con Google Chrome instalado):

```bash
bash docs/05-evidencias/generar-evidencias.sh
```

El script vuelve a tomar las 28 capturas, ejecuta las 27 pruebas (falla si alguna no pasa) y regenera el PDF.

Las pruebas también se pueden ver ejecutándose en el navegador abriendo `pruebas-mockups.html` desde GitHub Pages. Si se abre como archivo local, el navegador bloquea el acceso a los mockups y la página lo indica.
