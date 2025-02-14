#!/bin/bash
# Script de instalación para configurar mis dotfiles

# Variables (modifícalas según corresponda)
GIT_REPO="git@github.com:LBaquedanoCordova/repo-myconfig.git"
CFG_DIR="$HOME/.cfg"                                 # Ubicación del repo bare
WORK_TREE="$HOME"                                    # Área de trabajo (raíz de home)

# Clonar el repositorio bare, si no existe
if [ ! -d "$CFG_DIR" ]; then
  echo "Clonando el repositorio bare de dotfiles..."
  git clone --bare $GIT_REPO $CFG_DIR
fi

# Configurar el alias 'config'
# Se añade la línea al .bashrc si no existe aún
if ! grep -q "alias config=" "$HOME/.bashrc"; then
  echo "Agregando alias 'config' a .bashrc..."
  echo "alias config='git --git-dir=\$HOME/.cfg --work-tree=\$HOME'" >> "$HOME/.bashrc"
fi

# Recargar la configuración del shell
source "$HOME/.bashrc"

# Realizar el checkout de los dotfiles
echo "Realizando checkout de los dotfiles en el home..."
config checkout

# Configurar para que no se muestren archivos sin seguimiento
config config --local status.showUntrackedFiles no

echo "¡Instalación completada! Revisa tu configuración y reinicia la terminal si es necesario."
