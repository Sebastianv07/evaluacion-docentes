#!/usr/bin/env bash
# Genera las evidencias del proyecto con Chrome en modo headless:
#   1. Capturas de escritorio de los 24 estados de los mockups.
#   2. Capturas móviles reales (marco de 390 px).
#   3. Ejecución de las pruebas funcionales y captura de sus resultados.
#   4. El PDF de evidencias para la entrega.
# Uso (Git Bash en Windows):  bash docs/05-evidencias/generar-evidencias.sh
# Otra ruta de Chrome:        CHROME="/ruta/a/chrome" bash docs/05-evidencias/generar-evidencias.sh
set -euo pipefail

CHROME="${CHROME:-/c/Program Files/Google/Chrome/Application/chrome.exe}"
RAIZ="$(cd "$(dirname "$0")/../.." && pwd)"
M="$(cygpath -m "$RAIZ" 2>/dev/null || echo "$RAIZ")"
MOCK="file:///$M/docs/04-mockups"
OUT="$M/docs/05-evidencias/capturas"
TMP="$(mktemp -d)"; TMPM="$(cygpath -m "$TMP" 2>/dev/null || echo "$TMP")"
mkdir -p "$RAIZ/docs/05-evidencias/capturas"

# Cada llamada usa su propio perfil: si no, Chrome reutiliza la instancia anterior y no captura.
i=0
chrome(){ i=$((i+1)); "$CHROME" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
  --user-data-dir="$TMPM/perfil$i" --virtual-time-budget="${BUDGET:-2000}" "$@" 2>&1; }   # Chrome confirma las capturas por stderr
captura(){ chrome --window-size="$2" --screenshot="$OUT/$3.png" "$1" | grep -q "bytes written" && echo "  ✓ $3" || { echo "  ✗ $3"; exit 1; }; }

# Chrome en Windows no abre ventanas de menos de ~500 px: la vista móvil se mide dentro de un iframe de 390 px.
movil(){ # $1 = mockup#estado · $2 = alto del iframe · $3 = nombre
  cat > "$TMP/$3.html" <<EOF
<!doctype html><meta charset="utf-8"><style>html,body{margin:0;background:#DDE3EA}body{display:flex;justify-content:center;padding:24px 0}
.p{border:10px solid #1F2933;border-radius:28px;overflow:hidden;background:#fff}iframe{display:block;border:0;width:390px;height:$2px}</style>
<div class="p"><iframe src="$MOCK/$1"></iframe></div>
EOF
  captura "file:///$TMPM/$3.html" "520,$(( $2 + 68 ))" "$3"; }

echo "1. Capturas de escritorio"
for s in inicial cargando cedula-invalida error bloqueada exito recuperar enviado restablecer; do
  captura "$MOCK/0001-iniciar-sesion.html#$s" 1440,1000 "0001-$s"; done
for s in listado-vacio listado formulario error-suma error-campos guardando guardada; do
  captura "$MOCK/0002-crear-rubrica.html#$s" 1440,1250 "0002-$s"; done
for s in cargando diligenciando error-obligatorio borrador enviando enviada periodo-cerrado ya-evaluado; do
  captura "$MOCK/0003-diligenciar-evaluacion.html#$s" 1440,1300 "0003-$s"; done

echo "2. Capturas móviles (390 px)"
movil "0001-iniciar-sesion.html#error" 844 movil-0001-error
movil "0002-crear-rubrica.html#error-suma" 844 movil-0002-error-suma
movil "0003-diligenciar-evaluacion.html#error-obligatorio" 844 movil-0003-error-obligatorio
movil "0003-diligenciar-evaluacion.html#error-obligatorio" 2250 movil-0003-pagina-completa

echo "3. Pruebas funcionales"
PRUEBAS="file:///$M/docs/05-evidencias/pruebas-mockups.html"
RESULTADO="$(BUDGET=60000 chrome --dump-dom "$PRUEBAS" | grep -o 'TOTAL=[0-9]* PASAN=[0-9]* FALLAN=[0-9]*' || true)"
echo "  $RESULTADO"
BUDGET=60000 captura "$PRUEBAS" 1240,1500 pruebas-resultados

echo "4. PDF de evidencias"
PDF="$M/entrega/Proyecto - Evaluacion Docentes - Evidencias.pdf"
mkdir -p "$RAIZ/entrega"
BUDGET=60000 chrome --no-pdf-header-footer --print-to-pdf="$PDF" "file:///$M/docs/05-evidencias/informe-evidencias.html" >/dev/null
echo "  ✓ entrega/Proyecto - Evaluacion Docentes - Evidencias.pdf"

rm -rf "$TMP"
[[ "$RESULTADO" == *"FALLAN=0"* ]] || { echo "Hay pruebas que fallan"; exit 1; }
echo "Listo."
