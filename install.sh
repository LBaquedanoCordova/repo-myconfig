#!/usr/bin/env bash

echo "Detectando entorno..."
if grep -qEi "(microsoft|wsl)" /proc/version &> /dev/null; then
  ENVIRONMENT="wsl"
else
  ENVIRONMENT="windows"
fi

echo "Entorno detectado: $ENVIRONMENT"
echo "Preparando configuración..."

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_VSCODE="$REPO_DIR/vscode-config/$ENVIRONMENT/settings.json"

# Ruta destino para settings.json
if [ "$ENVIRONMENT" == "windows" ]; then
  VSCODE_SETTINGS_PATH="$APPDATA/Code/User/settings.json"
else
  VSCODE_SETTINGS_PATH="$HOME/.vscode-server/data/Machine/settings.json"
fi

# Función para hacer backup y copiar
copy_with_backup() {
  local source=$1
  local target=$2

  if [ ! -f "$source" ]; then
    echo "Archivo de origen no encontrado: $source"
    return
  fi

  if [ -f "$target" ]; then
    backup="${target}.backup-$(date +%s)"
    echo "Respaldando $target -> $backup"
    cp "$target" "$backup"
  fi

  echo "Copiando $source -> $target"
  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
}

# Archivos de configuración generales
copy_with_backup "$REPO_DIR/.bashrc" "$HOME/.bashrc"
copy_with_backup "$REPO_DIR/.bash_profile" "$HOME/.bash_profile"
copy_with_backup "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"

# Configuración de VS Code según entorno
copy_with_backup "$SOURCE_VSCODE" "$VSCODE_SETTINGS_PATH"

echo "Configuración aplicada correctamente."
