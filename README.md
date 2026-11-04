# Proyecto Final – Introducción al Software Libre (ISL135)

Universidad de El Salvador – Facultad Multidisciplinaria de Occidente
Ingeniería en Desarrollo de Software – Ciclo II 2026

## Grupo 9

| Carnet  | Nombre        | Apellido          |
|---------|---------------|-------------------|
| CM13032 | Luis Enrique  | Castro Monterroza |
| MV25018 | José Amilcar  | Mira Vásquez      |
| MO23002 | Angela Rebeca | Mena Ortiz        |
| LV19015 | Brenda Ivania | Laínez Vides      |

## Descripción

Servidor Linux automatizado con Docker: administración de usuarios y
permisos, monitoreo con cron, control de versiones con Git/GitHub y
servidores web con Nginx en contenedores.

## Estructura

    scripts/    # scripts de automatización
## Integrante 4 - Redes, volumenes y pruebas finales (Apartados 7 y 8)

### Red personalizada
- `sudo docker network create red-proyecto`
- `sudo docker run -d --name nginx-red --network red-proyecto -p 8082:80 nginx:latest`
- `sudo docker network inspect red-proyecto`

### Volumen persistente
- `sudo docker volume create volumen-web`
- `sudo docker run -d --name nginx-volumen -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx:latest`
- `sudo docker volume inspect volumen-web`
- Prueba de persistencia: se elimino y recreo `nginx-volumen` y el contenido se conservo.

### Pruebas finales
- Conectividad: `sudo docker run --rm --network red-proyecto alpine ping -c 4 nginx-red` (0% de perdida).
- Los cuatro servicios responden 200 en los puertos 8080, 8081, 8082 y 8083.
- Monitoreo automatico con cron cada 30 minutos verificado en `/var/log/reporte_sistema.log`.
- Evidencias: `docs/sesion_integrante4.log` y `docs/comandos_integrante4.txt`.
