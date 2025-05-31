---
author: Johannes Hörmann <me@aligator.dev>
date: DD.MM.YYYY
---

# Docker Level 2

* Simple full stack app
* Simple Dockerfile
* Best Practices
  * Group / split commands
  * Use pinned versions
  * Avoid too many sequential RUN
  * Multi Stage
  * Secrets
  * Small images
* Special knowledge
* Alpine

---

## What is Docker?

### Refresher:
~~~sh
echo "(See level 1: \`ssh ${SLIDE1_HOST:-localhost} -p${SLIDE1_PORT:-13372}\`)"
~~~

- Platform for containerized applications
- Lightweight, isolated environments
- Everything needed to run an app in one package

---

## Simple full stack app
Clone the repo
```bash
~~~sh
echo git clone ${SOURCE_PROTOCOL:-http}://${SOURCE_HOST:-localhost}:${SOURCE_PORT:-13372}/docker-slides.git
~~~
cd docker-slides/exercises/3_best_practice
cat frontend/Dockerfile
```

---

## Best practice
### Group / split commands

Layers are cached `sequentially`.  

So when just editing a source file  
-> you don't want to re-download all dependencies!
```Dockerfile
COPY . .
RUN npm i
RUN npm run build
```

---

## Best practice
### Group / split commands

```Dockerfile
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run build
```

---

## Best practice
### Use pinned versions

* `FROM node:latest` -> `FROM node:22`
* `npm i` -> `npm ci` or equivalent 

yarn is complicated... based on the version you use maybe this:

`yarn install --immutable --immutable-cache --check-cache`

----

## Best practice
### Avoid too many sequential RUN
Not in this example, but when installing system dependencies.

**Each `RUN` creates a new `layer` (`snapshot`) of the filesystem!**

```Dockerfile
RUN apt update
RUN apt upgrade -y
RUN apt install -y curl
```
vs
```Dockerfile
RUN apt update \
  && apt upgrade -y \
  && apt install -y curl \
  && rm -rf /var/cache/apt/archives
```

---

## Best practice
### Avoid too many sequential RUN
However to still have the benefits of caching you may still split `RUN` sometimes.

It is your responsibility to balance between 
grouping in one layer and splitting into multiple
layers for caching purposes.

---

## Best practice
### Multistage
Split the actions, and create `stages`:

* Each `FROM` creates a new stage.
* Each `FROM node:22 AS builder` may have a name.
* You can create new stages based on images or on previous stages:
```dockerfile
FROM builder
# ...
```
* When using a new base image you will start from scratch, but you can copy binaries from other layers.
```dockerfile
FROM nginx:stable-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
```
--> this results in a small final image only containing html, js, css and nginx as webserver.

---

## Best practice
### Secrets
Avoid `build` secrets to end up in the final stage.
* Use `ARG` not `ENV` for build-only secrets
* Avoid copying files to the final stage that have a secret
* Use MultyStage builds to create a clean final stage
* Best: use `--secret ` flag

---

## Best practice
### Secrets

`docker build --secret id=aws,src=$HOME/.aws/credentials .`
```Dockerfile
RUN --mount=type=secret,id=aws \
    AWS_SHARED_CREDENTIALS_FILE=/run/secrets/aws \
    aws s3 cp ...
```
This will make the secret only available in this single `RUN` command.

https://docs.docker.com/build/building/secrets/

**Still you must take care that this command does not persist the secret in any way in the final stage!**

---

## Best practice
### Small images
To avoid bloating the target / dev systems:
* Try to create small final stages
* Try to avoid unneeded layers
  * avoid creating a file in one run and removing it in the next run (e.g. due to **caches**)
* Add only files that are really needed in the image
  * You may use `.dockerignore` (more about this later)
  * You may use specific `COPY` commands
* Use already small base images (if possible)
  * e.g. alpine, scratch, debian slim, ...
  * However all of them have some catch!

# Special Docker Knowledge

---

## COPY vs ADD

* `COPY` is simpler and more explicit
* `ADD` has extra features:
  * Can download from URLs
  * Can extract tar files
* Best practice: Use `COPY` unless you need `ADD`'s features

---

## ENTRYPOINT vs CMD

* `ENTRYPOINT`: Defines the executable
* `CMD`: Provides default arguments
* Can be used together:
  * `ENTRYPOINT` sets the command
  * `CMD` sets default parameters
* `CMD` can be overridden at runtime

---

## Shell vs Exec Form

* Shell form: `CMD npm start`
* Exec form: `CMD ["npm", "start"]`
* Exec form is preferred in `CMD` and `ENTRYPOINT`:
  * No shell processing - NO ENV expansion (Common practice: `entrypoint.sh` script)
  * Better signal handling
  * More explicit
* Shell form is preferred in `RUN`:
  * There you want shell handling (e.g. `cmd1 && cmd2`)

---

## ARG vs ENV

* `ARG`: Build-time variables
* `ENV`: Runtime variables
* `ARG` values are not persisted in image (unless stored manually!)
* `ENV` values are available in container

---

## .dockerignore vs .gitignore

* `.dockerignore`: Excludes files from build context
* `.gitignore`: Excludes files from git
* Different purposes:
  * Build optimization vs version control
* **DIFFERENT SYNTAX** 
  https://zzz.buzz/2018/05/23/differences-of-rules-between-gitignore-and-dockerignore/