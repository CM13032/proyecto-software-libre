# Proyecto Final – Introducción al Software Libre (ISL135)

Universidad de El Salvador – Facultad Multidisciplinaria de Occidente
Departamento de Ingeniería y Arquitectura
Ingeniería en Desarrollo de Software / Educación en Línea – Ciclo II 2026

## Grupo 9

| Carnet  | Nombre        | Apellido          |
|---------|---------------|-------------------|
| CM13032 | Luis Enrique  | Castro Monterroza |
| MV25018 | José Amilcar  | Mira Vásquez      |
| MO23002 | Angela Rebeca | Mena Ortiz        |
| LV19015 | Brenda Ivania | Laínez Vides      |

## Descripción

Implementación de un servidor Linux automatizado mediante contenedores
Docker, integrando administración de sistemas, control de versiones y
virtualización. El proyecto incluye gestión de usuarios y permisos,
monitoreo automatizado con cron, repositorio Git/GitHub y servidores web
Nginx en contenedores (imagen oficial, imagen personalizada, red
personalizada y volumen persistente).

## Estructura del repositorio

```
.
├── Dockerfile   # imagen personalizada servidor-grupo9
├── README.md
├── scripts/     # scripts de automatización
│   ├── setup_servidor.sh
│   ├── reporte_sistema.sh
│   ├── instalar_docker.sh
│   └── red_volumenes.sh
├── web/         # sitio web (index.html)
└── docs/        # registros de comandos como evidencia
```

## Servicios y puertos

| Servicio                         | Puerto host | Descripción                     |
|----------------------------------|-------------|---------------------------------|
| Nginx oficial (`nginx-web`)      | 8080        | Monta el directorio `web/`      |
| Imagen `servidor-grupo9`         | 8081        | Construida con el `Dockerfile`  |
| Nginx en `red-proyecto`          | 8082        | Red Docker personalizada        |
| Nginx con `volumen-web`          | 8083        | Volumen persistente             |

## Pasos de instalación

### 1. Preparación del entorno servidor

El script `scripts/setup_servidor.sh` crea los grupos `soporte` y `web`,
los usuarios `adminsys`, `tecnico` y `visitante`, y asigna los privilegios:

- `adminsys`: grupo `sudo` y `soporte`
- `tecnico`: grupo `soporte`
- `visitante`: grupo `web`

Los directorios con herencia de grupo usan el bit SGID (`chmod 2770`),
de modo que los archivos nuevos heredan el grupo del directorio.

### 2. Automatización y monitoreo

El script `scripts/reporte_sistema.sh` registra fecha y hora, carga de
CPU, memoria RAM, espacio en disco y usuarios conectados en
`/var/log/reporte_sistema.log`.

```bash
chmod +x scripts/reporte_sistema.sh
sudo crontab -e
```

Tarea programada cada 30 minutos:

```
*/30 * * * * /ruta/al/repositorio/scripts/reporte_sistema.sh
```

Verificación:

```bash
sudo crontab -l
sudo tail -n 15 /var/log/reporte_sistema.log
```

### 3. Control de versiones

```bash
git clone git@github.com:CM13032/proyecto-software-libre.git
cd proyecto-software-libre
git add .
git commit -m "Descripción del cambio"
git pull --rebase
git push
```

Cada integrante sincroniza con `git pull --rebase` antes de subir
cambios, para evitar conflictos. El historial se consulta con
`git log --oneline`.

### 4. Docker

Instalación desde el repositorio oficial de Docker. En Linux Mint se usa
el codename de Ubuntu (`UBUNTU_CODENAME`), no el de Mint. Los comandos
están recopilados en `scripts/instalar_docker.sh`.

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Habilitar el servicio y permitir usar Docker sin `sudo`:

```bash
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
```

Verificación con el usuario `tecnico` (sin `sudo`):

```bash
su - tecnico
docker --version
docker run hello-world
docker ps -a
```

### 5. Servidor web containerizado

El sitio está en `web/index.html`. Contenedor Nginx en segundo plano,
puerto 8080, con `web/` montado en el directorio de Nginx:

```bash
sudo docker run -d --name nginx-web -p 8080:80 \
  -v "$(pwd)/web":/usr/share/nginx/html:ro nginx:latest
sudo docker ps
sudo docker logs nginx-web
```

Acceso: http://localhost:8080

### 6. Docker avanzado

`Dockerfile`:

```dockerfile
FROM nginx:latest
COPY web/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Construcción y ejecución (Docker exige nombres de imagen en minúsculas):

```bash
sudo docker build -t servidor-grupo9 -f Dockerfile .
sudo docker run -d --name servidor-grupo9 -p 8081:80 servidor-grupo9
```

Acceso: http://localhost:8081

### 7. Redes y volúmenes Docker

Red personalizada:

```bash
sudo docker network create red-proyecto
sudo docker run -d --name nginx-red --network red-proyecto -p 8082:80 nginx:latest
sudo docker network inspect red-proyecto
```

Volumen persistente (se eliminó y recreó el contenedor para comprobar
que el contenido se conserva):

```bash
sudo docker volume create volumen-web
sudo docker run -d --name nginx-volumen -p 8083:80 -v volumen-web:/usr/share/nginx/html nginx:latest
sudo docker volume inspect volumen-web
```

Estos pasos están recopilados en `scripts/red_volumenes.sh`.

### 8. Pruebas y verificación final

Conectividad entre contenedores (0 % de pérdida):

```bash
sudo docker run --rm --network red-proyecto alpine ping -c 4 nginx-red
```

Verificación de los cuatro servicios (todos responden 200):

```bash
for p in 8080 8081 8082 8083; do
  echo -n "Puerto $p: "
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:$p
done
sudo docker ps
```

Evidencias de comandos en `docs/sesion_integrante4.log` y
`docs/comandos_integrante4.txt`.