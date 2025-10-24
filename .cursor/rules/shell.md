# 📜 Shell/Bash: Reglas Específicas

## Header Obligatorio

```bash
#!/usr/bin/env bash
set -euo pipefail  # ALWAYS include
IFS=$'\n\t'

# Script: script-name.sh
# Purpose: Brief description in English
# Usage: ./script.sh <args>
# Author: [name]
# Date: YYYY-MM-DD
```

### ⚠️ IMPORTANTE: Código en Inglés

- Nombres de funciones: `check_docker_installed()` ✅ NO `verificar_docker_instalado()` ❌
- Variables: `server_name` ✅ NO `nombre_servidor` ❌
- Comentarios: `# Check if file exists` ✅ NO `# Verificar si existe` ❌
- Logs: `log_info "Server started"` ✅ NO `log_info "Servidor iniciado"` ❌
```

### Explicación de `set -euo pipefail`

- `set -e`: Exit si cualquier comando falla
- `set -u`: Exit si se usa variable no definida
- `set -o pipefail`: Exit si falla comando en pipe
- `IFS=$'\n\t'`: Internal Field Separator (evita word splitting)

---

## Validación de Argumentos

```bash
# Verificar número de argumentos
if [ $# -ne 2 ]; then
  echo "Usage: $0 <arg1> <arg2>" >&2
  exit 1
fi

# Asignar argumentos
readonly ARG1="$1"
readonly ARG2="$2"

# Validar que no estén vacíos
if [ -z "$ARG1" ] || [ -z "$ARG2" ]; then
  echo "Error: Arguments cannot be empty" >&2
  exit 1
fi
```

---

## Variables y Constantes

```bash
# ✅ Constantes (readonly)
readonly BASE_DIR="/opt/minecraft"
readonly MAX_RETRIES=3
readonly TIMEOUT=30

# ✅ Variables locales en funciones
function process_data() {
  local input_file="$1"
  local output_file="$2"
  # ...
}

# ✅ Variables con defaults
readonly PORT=${PORT:-25565}
readonly MEMORY=${MEMORY:-4G}

# ❌ NO usar variables globales innecesarias
# ❌ NO usar nombres genéricos (data, tmp, file)
```

---

## Verificar Dependencias

```bash
# Verificar comando existe
command -v docker >/dev/null 2>&1 || {
  echo "Error: docker is required but not installed." >&2
  exit 1
}

# Verificar múltiples comandos
for cmd in docker docker-compose jq; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Error: $cmd is required but not installed." >&2
    exit 1
  }
done

# Verificar archivo existe
if [ ! -f "config.yml" ]; then
  echo "Error: config.yml not found" >&2
  exit 1
fi

# Verificar directorio existe
if [ ! -d "/data" ]; then
  echo "Error: /data directory not found" >&2
  exit 1
fi
```

---

## Error Handling

```bash
# Trap para errores
trap 'error_handler $? $LINENO' ERR

error_handler() {
  local exit_code=$1
  local line_number=$2
  echo "Error on line $line_number (exit code: $exit_code)" >&2
  cleanup
  exit "$exit_code"
}

# Trap para cleanup
trap cleanup EXIT

cleanup() {
  echo "Cleaning up..."
  rm -f /tmp/temp_file_$$
  # Otros cleanups necesarios
}

# Trap para señales
trap 'echo "Script interrupted"; cleanup; exit 130' INT TERM
```

---

## Funciones

### Estructura

```bash
# Documentación obligatoria
# Brief description
# Args:
#   $1 - Description of first argument
#   $2 - Description of second argument
# Returns:
#   0 on success, 1 on error
# Outputs:
#   Writes message to stdout
function_name() {
  local arg1="$1"
  local arg2="$2"
  
  # Validar argumentos
  if [ -z "$arg1" ]; then
    echo "Error: arg1 is required" >&2
    return 1
  fi
  
  # Lógica
  # ...
  
  return 0
}
```

### Ejemplo Completo

```bash
# Check if Docker container is running
# Args:
#   $1 - container name
# Returns:
#   0 if running, 1 if not running, 2 if doesn't exist
is_container_running() {
  local container_name="$1"
  
  if [ -z "$container_name" ]; then
    echo "Error: container name is required" >&2
    return 2
  fi
  
  if docker ps --filter "name=^${container_name}$" --format "{{.Names}}" | grep -q "^${container_name}$"; then
    return 0
  else
    return 1
  fi
}
```

---

## Logging

### ⚠️ IMPORTANTE: Logs en Inglés, Sin Emojis

```bash
# Logging functions
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_warn() {
  echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_debug() {
  if [ "${DEBUG:-false}" = "true" ]; then
    echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $*"
  fi
}

# ✅ BUENO: Inglés, sin emojis
log_info "Starting server..."
log_error "Failed to connect to database"
log_warn "Port 25565 already in use"

# ❌ MALO: Español
log_info "Iniciando servidor..."
log_error "Falló conexión a base de datos"

# ❌ MALO: Emojis
log_info "🚀 Starting server..."
log_error "❌ Failed to connect"
```

---

## Operaciones con Archivos

```bash
# ✅ BUENO: Verificar antes de operar
if [ -f "config.yml" ]; then
  cp config.yml config.yml.bak
fi

# ✅ BUENO: Usar rutas relativas o variables
readonly CONFIG_DIR="./config"
cp "${CONFIG_DIR}/default.yml" "${CONFIG_DIR}/current.yml"

# ❌ MALO: No verificar existencia
cp config.yml config.yml.bak

# ❌ MALO: Rutas absolutas hardcodeadas
cp /home/user/config.yml /home/user/backup/

# ✅ BUENO: Crear directorio si no existe
mkdir -p /opt/minecraft/data

# ✅ BUENO: rm con validación
if [ -n "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
  rm -f "$TEMP_FILE"
fi

# ❌ PROHIBIDO: rm -rf sin validación
rm -rf "$DIRECTORY"  # Muy peligroso si $DIRECTORY está vacío
```

---

## Operaciones con cd

```bash
# ✅ BUENO: Verificar éxito de cd
if ! cd /opt/minecraft; then
  echo "Error: Cannot change to /opt/minecraft" >&2
  exit 1
fi

# ✅ BUENO: Usar pushd/popd
pushd /opt/minecraft || exit 1
# hacer operaciones
popd || exit 1

# ✅ BUENO: Ejecutar en subshell
(cd /opt/minecraft && ./script.sh)

# ❌ MALO: cd sin verificar
cd /opt/minecraft
./script.sh  # Si cd falló, esto se ejecuta en directorio incorrecto
```

---

## Loops

```bash
# ✅ BUENO: Iterar sobre archivos
for file in *.log; do
  if [ -f "$file" ]; then  # Verificar que existe
    process_file "$file"
  fi
done

# ✅ BUENO: Iterar sobre líneas
while IFS= read -r line; do
  process_line "$line"
done < input.txt

# ✅ BUENO: Loop con contador
for i in {1..10}; do
  echo "Iteration $i"
done

# ✅ BUENO: Loop infinito con break
while true; do
  if check_condition; then
    break
  fi
  sleep 1
done

# ❌ MALO: for loop sin verificar existencia
for file in *.log; do
  process_file "$file"  # Fallará si no hay archivos .log
done
```

---

## Condicionales

```bash
# ✅ Usar [[ ]] en lugar de [ ]
if [[ "$var" == "value" ]]; then
  # ...
fi

# ✅ Comparación de strings
if [[ "$str1" == "$str2" ]]; then
  echo "Strings are equal"
fi

# ✅ Verificar string vacío
if [[ -z "$var" ]]; then
  echo "Variable is empty"
fi

if [[ -n "$var" ]]; then
  echo "Variable is not empty"
fi

# ✅ Verificar archivos
if [[ -f "file.txt" ]]; then
  echo "File exists"
fi

if [[ -d "directory" ]]; then
  echo "Directory exists"
fi

if [[ -x "script.sh" ]]; then
  echo "File is executable"
fi

# ✅ Operadores lógicos
if [[ "$a" == "1" && "$b" == "2" ]]; then
  echo "Both conditions true"
fi

if [[ "$a" == "1" || "$b" == "2" ]]; then
  echo "At least one condition true"
fi
```

---

## Ejecución de Comandos

```bash
# ✅ BUENO: Capturar output
output=$(command 2>&1)
exit_code=$?
if [ $exit_code -ne 0 ]; then
  echo "Command failed: $output" >&2
  exit 1
fi

# ✅ BUENO: Verificar exit code
if docker build -t image:tag .; then
  echo "Build successful"
else
  echo "Build failed" >&2
  exit 1
fi

# ❌ MALO: Ignorar exit code
command
# continuar sin verificar si falló

# ❌ PROHIBIDO: eval (riesgo de seguridad)
eval "$user_input"

# ❌ PROHIBIDO: Command substitution inseguro
result=$(cat file)  # Puede fallar silenciosamente
```

---

## Strings y Parámetros

```bash
# ✅ Siempre quotear variables
echo "$variable"
cp "$source" "$destination"

# ✅ Default values
echo "${VAR:-default}"

# ✅ Substring
string="hello world"
echo "${string:0:5}"  # "hello"

# ✅ Replace
echo "${string/world/bash}"  # "hello bash"

# ✅ Length
echo "${#string}"  # 11

# ❌ MALO: No quotear
echo $variable  # Puede causar word splitting
```

---

## Arrays

```bash
# ✅ Declarar array
declare -a servers=("server1" "server2" "server3")

# ✅ Iterar array
for server in "${servers[@]}"; do
  echo "Processing $server"
done

# ✅ Longitud de array
echo "${#servers[@]}"

# ✅ Agregar elemento
servers+=("server4")

# ✅ Array asociativo
declare -A config
config[host]="localhost"
config[port]="25565"

# ✅ Iterar array asociativo
for key in "${!config[@]}"; do
  echo "$key = ${config[$key]}"
done
```

---

## Testing Scripts

```bash
# Usar shellcheck
shellcheck script.sh

# Ejecutar con bash -x para debug
bash -x script.sh

# Ejecutar con bash -n para syntax check
bash -n script.sh

# Test específicos
# tests/test_script.sh
#!/usr/bin/env bash
set -euo pipefail

# Source script to test
source ../script.sh

# Test function
test_function_name() {
  result=$(function_name "arg1")
  if [[ "$result" != "expected" ]]; then
    echo "FAIL: Expected 'expected', got '$result'"
    return 1
  fi
  echo "PASS: function_name"
  return 0
}

# Run tests
test_function_name
```

---

## Patrones Prohibidos

```bash
# ❌ Emojis en código
echo "🚀 Starting..."
log_info "✅ Success"

# ❌ rm -rf sin validación
rm -rf "$DIR"

# ❌ cd sin verificar
cd /some/path
./script.sh

# ❌ eval con input de usuario
eval "$user_input"

# ❌ sudo en scripts
sudo apt-get install

# ❌ Rutas absolutas hardcodeadas
cp /home/user/file /home/user/backup/

# ❌ Ignorar exit codes
command
next_command

# ❌ Variables sin quotear
cp $source $destination

# ❌ $(cat file) innecesario
content=$(cat file)  # Usar: content=$(<file)
```

---

## Mejores Prácticas

```bash
# ✅ Usar readonly para constantes
readonly MAX_RETRIES=3

# ✅ Usar local en funciones
function_name() {
  local var="value"
}

# ✅ Verificar número de argumentos
if [ $# -ne 2 ]; then
  echo "Usage: $0 arg1 arg2" >&2
  exit 1
fi

# ✅ Usar traps para cleanup
trap cleanup EXIT

# ✅ Logging estructurado
log_info "Message"

# ✅ Documentar funciones
# Description
# Args: ...
# Returns: ...
function_name() { }

# ✅ Validar dependencias
command -v docker >/dev/null 2>&1 || exit 1

# ✅ Exit codes descriptivos
exit 0  # Success
exit 1  # General error
exit 2  # Misuse of command
```

---

## Template Completo

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script: template.sh
# Purpose: Template for new scripts
# Usage: ./template.sh <arg1> <arg2>
# Author: [name]
# Date: YYYY-MM-DD

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="/var/log/${SCRIPT_NAME}.log"

# Configuration
readonly MAX_RETRIES=3
readonly TIMEOUT=30

# Logging
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE" >&2
}

# Error handling
trap 'error_handler $? $LINENO' ERR
trap cleanup EXIT

error_handler() {
  log_error "Error on line $2 (exit code: $1)"
  cleanup
  exit "$1"
}

cleanup() {
  log_info "Cleaning up..."
  # Add cleanup code here
}

# Validate dependencies
check_dependencies() {
  for cmd in docker jq; do
    command -v "$cmd" >/dev/null 2>&1 || {
      log_error "$cmd is required but not installed"
      exit 1
    }
  done
}

# Main function
main() {
  # Validate arguments
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <arg1> <arg2>" >&2
    exit 1
  fi
  
  local arg1="$1"
  local arg2="$2"
  
  log_info "Starting script..."
  
  check_dependencies
  
  # Main logic here
  
  log_info "Script completed successfully"
}

# Run main function
main "$@"
```

---

## Referencias

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

---

**Última actualización:** 2025-10-24

