#!/bin/bash

# Definir la ruta del archivo de registro
LOG_FILE="/var/log/reporte_sistema.log"

# Encabezado del reporte con fecha y hora actual
echo "REPORTE DEL SISTEMA - $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG_FILE

# Uso de cpu (Carga promedio)
echo "USO DE CPU (Carga promedio)" >> $LOG_FILE
uptime | awk -F'load average:' '{ print $2 }' >> $LOG_FILE

# Uso de memoria RAM
echo "USO DE MEMORIA RAM" >> $LOG_FILE
free -h >> $LOG_FILE

# Espacio en disco
echo "ESPACIO EN DISCO" >> $LOG_FILE
df -h / >> $LOG_FILE

# Usuarios conectados
echo "USUARIOS CONECTADOS" >> $LOG_FILE
who >> $LOG_FILE

echo "" >> $LOG_FILE
