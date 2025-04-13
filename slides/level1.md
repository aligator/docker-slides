---
author: Johannes Hörmann <me@aligator.dev>
date: DD.MM.YYYY
---

# Docker Level 1

* Brief introduction
* First Hello container
* Basic Wording
* First Dockerfile
* First Compose file
* Common docker / compose commands
* Final Exercise: Dockerize a Web App

---

## Fetch exercise sources

To do the exercises you need to fetch the sources:
```bash
git clone http://aligator.dev:13372/docker-slides.git
```

---

## What is Docker?

- Platform for containerized applications
- Lightweight, isolated environments
- Everything needed to run an app in one package

---

## What is Docker?

- Based on `isolation features` of the Linux kernel
 - Needs a linux to run. (Native (linux), WSL-VM (win), VM (mac))
 - Many isolated `containers` all share the same kernel
 - Lightweight (on top of linux)
  * No separate VM for each container

---

## What is Docker?
### Question:
**The real advantage compared to a lightweight VM**

* VMs allocate fixed resources:
  * RAM is reserved even when idle
  * Disk space is pre-allocated
  * Each VM needs its own full OS kernel

---

## What is Docker?
### Question:
**The real advantage compared to a lightweight VM**

* Docker containers:
  * Share the host's linux kernel
  * Use resources dynamically
  * Only consume what they actually need
  * Start in seconds (vs minutes for VMs)
  * Much smaller disk footprint (if you clean up your no longer needed images / volumes :-)
  * Lower memory overhead

You can see containers as processes with `htop` because they are just isolated processes on the host system.
---

## Hello World

```bash
docker run hello-world
```
- Pulls image if not present [Dockerhub](https://hub.docker.com/_/hello-world)
- Creates container
- Runs it
- Shows output
- Stops automatically

---

## Basic Concepts
### Image

- Read-only template
- Contains everything to run an app:
  * Code
  * Runtime
  * Libraries
  * Environment variables
  * Config files
- Built from `Dockerfile`
- Stored in layers
- Shared via registries (Docker Hub)
- Versioned with tags

---

## Basic Concepts
### Image

Try:  
* `docker image ls`  
* `docker image inspect hello-world`  

---

## Basic Concepts
### Container

- Running `instance` of an image
- Has its own:
  * Process space
  * Network interface
  * File system
- Can be:
  * Started/stopped
  * Paused/resumed
  * Removed

Try:
`docker container ls -a`
`docker container inspect <container-id>`

---

## Exercise 1: Run a Web Server

1. Go to `exercises/1_simple/`
2. Run it locally:
```bash
node server.js
```

---

## Exercise 1: Run a Web Server

3. Run it in Docker:
```bash
docker run -p 3000:3000 -v $(pwd):/app -w /app node:22 node server.js
```

---

## Exercise 1: Run a Web Server

4. Test it:
```bash
curl http://localhost:3000
```

---

## Exercise 1: Run a Web Server

What happened?
- `-p 3000:3000`: Port mapping
- `-v $(pwd):/app`: Volume mount
- `-w /app`: Working directory
- `node:22`: Base image
- `node server.js`: Command to run

---

## First Dockerfile

Let's create our own image:

```dockerfile
FROM node:22
WORKDIR /app
COPY server.js .
EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["server.js"]
```

---

## First Dockerfile

Build and run:
```bash
docker build -t my-server .
docker run -p 3000:3000 my-server
```

---

## First Dockerfile
### FROM

- First instruction in every Dockerfile
- Specifies base image
- Common bases:
  * `node:22` - Node.js
  * `python:3.11` - Python
  * `nginx:alpine` - Web server
  * `ubuntu:22.04` - Ubuntu
- Always use specific versions (default is `:latest`)
- Prefer smaller images (alpine)

---

## First Dockerfile
### WORKDIR

- Sets working directory (e.g. a `cd`)
- Creates directory if not exists
- All following commands run here
- Relative paths are relative to WORKDIR
- Best practice: Use absolute paths

---

## First Dockerfile
### COPY

- Copies files from host to container
- Two arguments:
  * Source (relative to build context)
  * Destination (relative to WORKDIR)
- Can copy multiple files
- Can use wildcards (`*.js`)
- Preserves file permissions

---

## First Dockerfile
### EXPOSE

- Documents which ports container uses
- **Doesn't actually publish ports**
- Just documentation
- Helps other developers
- Use with `-p3000:3000` in `docker run` to actually export the ports

---

## First Dockerfile
### ENTRYPOINT

- Main binary to run
- Only one ENTRYPOINT per Dockerfile
- Can be overridden at runtime
- Two forms:
  * Shell form: `ENTRYPOINT node`
  * Exec form: `ENTRYPOINT ["node"]`
- Prefer exec form

---

## First Dockerfile
### CMD

- Added as "parameters" to the `ENTRYPOINT`
- Only one CMD per Dockerfile
- Can be overridden at runtime
- Two forms:
  * Shell form: `CMD server.js`
  * Exec form: `CMD ["server.js"]`
- Prefer exec form

---

## First Compose File

Why Compose?
- Manage multiple containers
- Define networks
- Share volumes
- Set environment variables
- One command to start/stop

---

## First Compose File

Example `docker-compose.yaml` / `compose.yaml`:
```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"

    # optionally:
    volumes:
      - .:/app
    environment:
      - NODE_ENV=development
```

---

## First Compose File

Run with:
```bash
docker compose up
docker compose down
```

---

## Compose YAML Explained
### Services
```yaml
services:
  web:
```
- Top-level key for container definitions
- `web` is the service name
- Can have multiple services (e.g., `db`, `redis`)

---

## Compose YAML Explained
### Build
```yaml
    build: .
```
- Builds image from Dockerfile
- `.` is the build context
- Can use pre-built images with `image: name`

---

## Compose YAML Explained
### Ports
```yaml
    ports:
      - "3000:3000"
```
- Maps host:container ports
- Left: **host** port
- Right: **container** port
- Can use ranges: `"3000-3005:3000-3005"`

---

## Compose YAML Explained
### Volumes
```yaml
    volumes:
      - .:/app
```
- Mounts host directories
- Left: **host*** path
- Right: **container** path
- Can be named volumes too (more later)

---

## Compose YAML Explained
### Environment
```yaml
    environment:
      - NODE_ENV=development
```
- Sets environment variables
- Can instead use `.env` file `env_file: "my.env"`
- Can use `${VAR}` syntax

---

## Common docker / compose commands
### Docker Images

* List images
  ```bash
  docker image ls
  ```
* Build image
  ```bash
  docker build -t my-image .
  ```
* Remove image
  ```bash
  docker image rm my-image
  ```

---

## Common docker / compose commands
### Docker Containers

* List containers
  ```bash
  docker container ls -a
  ```
* Run container
  ```bash
  docker run -d -p 3000:3000 my-image
  ```
* Stop container
  ```bash
  docker stop <container-id>
  ```

---

## Common docker / compose commands
### Docker Debugging

* Execute command in container
  ```bash
  docker exec -it <container-id> /bin/bash
  ```
* View container details
  ```bash
  docker inspect <container-id>
  ```
* View logs
  ```bash
  docker logs <container-id>
  ```

---

## Common docker / compose commands
### Compose Basic

* Start services
  ```bash
  docker compose up
  ```
* Start in background
  ```bash
  docker compose up -d
  ```
* Stop services
  ```bash
  docker compose down
  ```

---

## Common docker / compose commands
### Compose Development

* Rebuild images
  ```bash
  docker compose build
  ```
* Restart services
  ```bash
  docker compose restart
  ```
* View service status
  ```bash
  docker compose ps
  ```

---

## Common docker / compose commands
### Compose Debugging

* Execute command in service
  ```bash
  docker compose exec web /bin/bash
  ```
* View service logs
  ```bash
  docker compose logs web
  ```
* Follow logs
  ```bash
  docker compose logs -f
  ```

---

## Final Exercise: Dockerize a Web App

We have a simple web application in `slides/exercises/2_express`:
* Express backend (`/backend`)
* Simple HTML frontend (`/frontend`)

Your challenge:
Write Dockerfiles for both services!

---

## Final Exercise: Requirements

* Create a Dockerfile for the backend
* Create a Dockerfile for the frontend
* Backend should run on port 3000
* Frontend should be served by a web server
* Both should be accessible in browser

---

## Final Exercise: Requirements

Hints:
* Check the `slides/exercises/2_express` folder for the code
* Remember to install dependencies `RUN npm ...`
* Think about port exposure

