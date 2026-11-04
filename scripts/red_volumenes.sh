#!/bin/bash
# Integrante 4 - Apartados 7 y 8: redes, volumenes y pruebas finales
# Ejecutar con: sudo bash scripts/red_volumenes.sh
# Apartado 7: red y volumen
docker network create red-proyecto
docker run -d --name nginx-red --network red-proyecto -p 8082:80 nginx:latest
docker volume create volumen-web
docker run -d --name nginx-volumen -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx:latest
docker network inspect red-proyecto
docker volume inspect volumen-web
docker run --rm --network red-proyecto alpine ping -c 4 nginx-red
# Apartado 8: verificacion de los cuatro servicios
for p in 8080 8081 8082 8083; do
echo -n "Puerto $p: "
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:$p
done
docker ps
tail -n 20 /var/log/reporte_sistema.log
