#!/bin/bash
#verificación parámetros para que no caiga
if [ $# -ne 3 ]; then
	echo "Debe pasar 3 argumentos: usuario, grupo, y archivo"
	exit 1
fi

USUARIO=$1
GRUPO=$2
ARCHIVO=$3

#verificación de root
if [ "$(whoami)" != "root" ]; then
	echo "Debe ejecutar el script como root"
	exit 1
fi

#verificación de archivo
if [ ! -f "$ARCHIVO" ]; then
	echo "EL archivo no existe"
	exit 1
fi

#verificación de grupo
if cat /etc/group | grep -q "^$GRUPO:"; then
	echo "El grupo $GRUPO ya existe"
else 
	groupadd "$GRUPO"
	echo "Se creó el grupo: $GRUPO"
fi

#verificación de usuario
if cat /etc/passwd | grep -q "^$USUARIO:"; then
	echo "El usario $USUARIO ya existe"
	usermod -aG "$GRUPO" "$USUARIO"
else
	echo "Se creará el usuario $USUARIO y se agregará al grupo $GRUPO"
	adduser "$USUARIO"
	usermod -aG "$GRUPO" "$USUARIO"
fi

#cambiar propietario y grupo
chown "$USUARIO:$GRUPO" "$ARCHIVO"

#cambiar permisos
chmod u=rwx,g=r,o=  "$ARCHIVO"
