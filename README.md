# Proyecto Final – Introducción al Software Libre (ISL135)

Universidad de El Salvador – Facultad Multidisciplinaria de Occidente
Departamento de Ingeniería y Arquitectura
Ingeniería en Desarrollo de Software – Ciclo II 2026

## Grupo 9

| Carnet  | Nombre        | Apellido          | Apartados |
|---------|---------------|-------------------|-----------|
| CM13032 | Luis Enrique  | Castro Monterroza | 1 y 2     |
| LV19015 | Brenda Ivania | Laínez Vides      | 3 y 4     |
| MO23002 | Angela Rebeca | Mena Ortiz        | 5 y 6     |
| MV25018 | José Amilcar  | Mira Vásquez      | 7 y 8     |



## Descripción

Servidor Linux automatizado con Docker. El proyecto integra administración
de usuarios y permisos, monitoreo con cron, control de versiones con
Git/GitHub y servidores web Nginx en contenedores, con redes y volúmenes
persistentes.

## Estructura del repositorio

    proyecto-software-libre/
    ├── Dockerfile          # imagen personalizada servidor-grupox
    ├── README.md           # documentación del proyecto
    ├── web/
    │   └── index.html      # sitio web del proyecto
    ├── scripts/
    │   ├── setup_servidor.sh     # preparación del servidor
    │   ├── reporte_sistema.sh    # monitoreo del sistema (cron)
    │   ├── instalar_docker.sh    # instalación de Docker
    │   └── red_volumenes.sh      # redes, volúmenes y pruebas finales
    └── docs/
        ├── sesion_integrante4.log      # registro grabado de la sesión
        └── comandos_integrante4.txt    # comandos utilizados

## Fase 1. Preparación del entorno servidor (Apartado 1)

- Hostname del servidor: `servidor-grupoX`.
- Usuarios: `adminsys`, `tecnico` y `visitante`.
- Grupos: `soporte` y `web`.
  - `adminsys` pertenece al grupo `sudo`.
  - `tecnico` pertenece al grupo `soporte`.
  - `visitante` pertenece al grupo `web`.
- Estructura de directorios en `/proyecto/`: `datos/`, `web/`, `scripts/`
  y `capturas/`, con permisos de grupo y herencia de grupo (bit setgid).
- Script utilizado: `scripts/setup_servidor.sh`.

## Fase 2. Automatización y monitoreo (Apartado 2)

- `scripts/reporte_sistema.sh` registra fecha y hora, carga de CPU, memoria
  RAM, espacio en disco y usuarios conectados.
- Tarea de cron cada 30 minutos:

      */30 * * * * /ruta/al/proyecto/scripts/reporte_sistema.sh

- Salida del monitoreo: `/var/log/reporte_sistema.log`.
- Verificación: `sudo crontab -l` y
  `sudo grep REPORTE /var/log/reporte_sistema.log | tail -n 6`.

## Fase 3. Control de versiones (Apartado 3)

- Repositorio Git local inicializado y repositorio remoto en GitHub.
- Primer commit con la estructura del proyecto, subido con `git push`.
- Cada integrante aporta con sus propios commits (ver `git log`).

## Fase 4. Docker (Apartado 4)

Instalación automatizada con `scripts/instalar_docker.sh`:

    sudo apt update
    sudo apt install -y ca-certificates curl gnupg
    # agregar la llave y el repositorio oficial de Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker adminsys
    sudo usermod -aG docker tecnico
    sudo docker run hello-world
    sudo docker ps -a

Se verificó que `tecnico` ejecuta `docker run hello-world` sin `sudo`.

## Fase 5. Servidor web containerizado (Apartado 5)

    sudo docker run -d --name nginx-web -p 8080:80 \
        -v "$(pwd)/web":/usr/share/nginx/html:ro nginx:latest
    sudo docker logs nginx-web | tail -n 5

Se accede desde el navegador en `http://localhost:8080`.

## Fase 6. Docker avanzado (Apartado 6)

`Dockerfile` en la raíz del repositorio:

    FROM nginx:latest
    COPY web/ /usr/share/nginx/html/
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]

Construcción y ejecución:

    sudo docker build -t servidor-grupox -f Dockerfile .
    sudo docker run -d --name servidor-grupox -p 8081:80 servidor-grupox

Se accede en `http://localhost:8081` y se compara con el Nginx oficial
del puerto 8080.

## Fase 7. Redes y volúmenes Docker (Apartado 7)

### Red personalizada

    sudo docker network create red-proyecto
    sudo docker run -d --name nginx-red --network red-proyecto -p 8082:80 nginx:latest
    sudo docker network inspect red-proyecto

### Volumen persistente

    sudo docker volume create volumen-web
    sudo docker run -d --name nginx-volumen -p 8083:80 \
        -v volumen-web:/usr/share/nginx/html nginx:latest
    sudo docker volume inspect volumen-web

Prueba de persistencia: se eliminó `nginx-volumen` con `docker rm -f`, se
creó de nuevo con el mismo volumen y el contenido se conservó.

## Fase 8. Pruebas y verificación final (Apartado 8)

- Conectividad con Alpine Linux:

      sudo docker run --rm --network red-proyecto alpine ping -c 4 nginx-red

  Resultado: 4 paquetes enviados y recibidos, 0 % de pérdida.

- Verificación de los cuatro servicios:

      for p in 8080 8081 8082 8083; do
        echo -n "Puerto $p: "
        curl -s -o /dev/null -w "%{http_code}\n" http://localhost:$p
      done

  Resultado: código 200 en los cuatro puertos.

- Contenedores activos: `sudo docker ps`.
- Monitoreo automático: entradas en `/var/log/reporte_sistema.log`
  separadas por 30 minutos.

## Resumen de servicios

| Puerto | Contenedor      | Descripción                          |
|--------|-----------------|--------------------------------------|
| 8080   | nginx-web       | Nginx oficial con `web/` montado     |
| 8081   | servidor-grupox | Imagen personalizada (Dockerfile)    |
| 8082   | nginx-red       | Nginx en la red `red-proyecto`       |
| 8083   | nginx-volumen   | Nginx con el volumen `volumen-web`   |

## Evidencias

- `docs/sesion_integrante4.log`: registro grabado con `script`.
- `docs/comandos_integrante4.txt`: comandos utilizados.
- Capturas de pantalla: incluidas en el informe PDF.