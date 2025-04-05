# Docker Level 1

* Brief introduction
* First Hello container
* Basic Wording
* First Dockerfile
* First Compose file
* Volumes
* Bind mounts

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
`docker image ls`
`docker image inspect hello-world`

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
CMD ["node", "server.js"]
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
### CMD

- Default command to run
- Only one CMD per Dockerfile
- Can be overridden at runtime
- Two forms:
  * Shell form: `CMD node server.js`
  * Exec form: `CMD ["node", "server.js"]`
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

Run with:
```bash
docker compose up
docker compose down
```

