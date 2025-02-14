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

## Automatización de la Configuración

Se ha incorporado un script de instalación en la rama automation para automatizar el proceso anterior. Con este script, en una máquina nueva solo tendrás que ejecutar un único comando para clonar el repositorio bare, configurar el alias y realizar el checkout.

### Ejecuta el siguiente comando en una nueva máquina:

curl -Lks https://raw.githubusercontent.com/LBaquedanoCordova/repo-myconfig/refs/heads/automation/install.sh | bash


El script realiza las siguientes operaciones:

-Clona el repositorio bare (si no existe) en $HOME/.cfg.
-Agrega el alias config a tu archivo .bashrc (si aún no está definido).
-Recarga la configuración del shell para que el alias esté disponible.
-Realiza el checkout de los dotfiles en tu directorio $HOME.
-Configura Git para que no se muestren archivos sin seguimiento, manteniendo la salida de config status limpia.

Con esta automatización, la configuración de tus dotfiles queda preparada de forma rápida y sin tener que ejecutar manualmente cada comando.