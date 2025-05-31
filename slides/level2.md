# Docker Level 2

* Deeper technical introduction
* Introduce simple node server and react app
* Write simple Dockerfile
* Best Practices
  * Multi Stage

* Special knowledge
  * `COPY` vs `ADD`
  * `ENTRYPOINT` vs `CMD`
  * Shell vs Exec Form
  * `ARG` vs `ENV`
  * `.dockerignore` vs `.gitignore`
* Why Alpine

---

## What is Docker?

- Platform for containerized applications
- Lightweight, isolated environments
- Everything needed to run an app in one package

---

## Docker vs VMs
### Docker
- Based on `isolation features` of the Linux kernel
 - Needs a linux to run.
 - Many isolated `containers` all share the same kernel.n
 - Lightweight (on top of linux)

---

## Docker vs VMs
### VM
- Runs a full OS for each
- Independent of the host OS
- But locks resources for each VM

---

## Docker vs VMs
### Docker on Win / Mac
- No linux kernel exists.
 - Docker Desktop starts **1** Linux VM
 - Inside it you can start your containers

- Windows leverages WSL which already has a Linux VM
- Mac Docker Desktop starts a separate Linux VM
- Linux obviously needs no VM as it can run on the host
 - No VM -> No Overhead -> Extremely lightweight

---

## First Dockerfile
### Shell vs Exec Form
#### Shell form

```dockerfile
# Shell form
ENTRYPOINT node server.js
```

- Runs through `/bin/sh -c`
- Shell processes the command
- Signal handling issues
- Environment variable expansion

---

## First Dockerfile
### Shell vs Exec Form
#### Exec form

```dockerfile
ENTRYPOINT ["node", "server.js"]
```

- Direct execution
- No shell involved
- Better signal handling
- More predictable behavior

---
