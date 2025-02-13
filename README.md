# 🎛️ Gestión de Dotfiles con Git  

Este repositorio almacena y administra mis archivos de configuración (dotfiles) utilizando un repositorio `bare` de Git.  

## 🚀 ¿Qué es esta técnica?  
En lugar de usar herramientas adicionales para manejar los dotfiles, este método usa un repositorio `bare` en `$HOME/.cfg`, lo que permite versionar archivos de configuración sin interferir con otros repositorios de Git.  

## 🛠️ Instalación y Configuración  

### 1️⃣ **Clonar el repositorio**  
Si configuro un nuevo equipo, puedo restaurar mi configuración con:  

```bash
git clone --bare git@github.com:LBaquedanoCordova/repo-myconfig.git $HOME/.cfg
alias config='/mingw64/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
