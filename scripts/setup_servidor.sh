#!/bin/bash

# Creacion de grupos
sudo groupadd soporte
sudo groupadd web

#Creacion de usuarios
sudo useradd -m -s /bin/bash adminsys
sudo useradd -m -s /bin/bash tecnico
sudo useradd -m -s /bin/bash visitante

#Asignacion de contrasenas
echo "adminsys:admin123" | sudo chpasswd
echo "tecnico:tecnico123" | sudo chpasswd
echo "visitante:visitante123" | sudo chpasswd

#Asignacion de grupos y privilegios
sudo usermod -aG soporte,sudo adminsys
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante

#Creacion de la estructura de directorios /proyecto/
sudo mkdir -p /proyecto/documentos
sudo mkdir -p /proyecto/codigo
sudo mkdir -p /proyecto/publico

#Configuracion de permisos y herencia SGID
sudo chown -R :soporte /proyecto/documentos
sudo chmod -R 2770 /proyecto/documentos

sudo chown -R :soporte /proyecto/codigo
sudo chmod -R 2770 /proyecto/codigo

sudo chown -R :web /proyecto/publico
sudo chmod -R 777 /proyecto/publico

echo "Configuración del servidor completada."
