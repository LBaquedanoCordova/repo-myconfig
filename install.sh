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
  # Si APPDATA no existe, usar USERPROFILE para reconstruirlo
  if [ -z "$APPDATA" ]; then
    APPDATA="$USERPROFILE/AppData/Roaming"
  fi
  VSCODE_SETTINGS_PATH="$APPDATA/Code/User/settings.json"
else
  VSCODE_SETTINGS_PATH="$HOME/.vscode-server/data/Machine/settings.json"
fi

#Función para respaldar archivo eliminando versiones anteriores
backup_once() {
  local target="$1"
  local backup="${target}.backup"

  if [ -f "$target" ]; then
    echo "Eliminando respaldos anteriores de $target..."
    find "$(dirname "$target")" -maxdepth 1 -type f \
      -name "$(basename "$target").backup*" -exec rm -f {} +

    echo "Respaldando $target -> $backup"
    cp "$target" "$backup"
  fi
}

#Función para copiar archivo fuente a destino con respaldo único
copy_with_single_backup() {
  local source="$1"
  local target="$2"

  if [ ! -f "$source" ]; then
    echo "Archivo fuente no encontrado: $source"
    return
  fi

  backup_once "$target"

  echo "Copiando $source -> $target"
  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
}

#Centralizar alias personalizados
ensure_dotfiles_aliases() {
  local alias_file="$HOME/.my_dotfiles_aliases"
  local bashrc="$HOME/.bashrc"
  local alias_line="alias config='git --git-dir=\$HOME/.cfg --work-tree=\$HOME'"

  if [ ! -f "$alias_file" ]; then
    echo "Creando archivo personalizado: $alias_file"
    echo "$alias_line" > "$alias_file"
  elif ! grep -Fxq "$alias_line" "$alias_file"; then
    echo "Agregando alias a $alias_file"
    echo "$alias_line" >> "$alias_file"
  else
    echo "Alias ya existe en $alias_file"
  fi

  local source_line='[ -f ~/.my_dotfiles_aliases ] && source ~/.my_dotfiles_aliases'

  if ! grep -Fq "$source_line" "$bashrc"; then
    echo "Vinculando $alias_file desde .bashrc"
    echo -e "\n# Alias personalizados\n$source_line" >> "$bashrc"
  else
    echo ".bashrc ya incluye referencia a $alias_file"
  fi
}

#Aplicar configuración
copy_with_single_backup "$REPO_DIR/.bash_profile" "$HOME/.bash_profile"
copy_with_single_backup "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
copy_with_single_backup "$SOURCE_VSCODE" "$VSCODE_SETTINGS_PATH"

#Modularizar alias personalizados
ensure_dotfiles_aliases

echo "Configuración aplicada exitosamente."
