FROM golang:1.24.0-alpine AS builder

# Set Caddy version
ARG CADDY_VERSION=2.9.1

# Install necessary build tools
RUN apk add --no-cache git gcc musl-dev

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with the specified plugins
RUN xcaddy build v${CADDY_VERSION} \
    --output /usr/local/bin/caddy \
    --with=github.com/aksdb/caddy-cgi/v2

FROM caddy:alpine
RUN apk add --no-cache git git-daemon

COPY --from=builder /usr/local/bin/caddy /usr/bin/caddy

COPY . /srv/app
RUN mv /srv/app/docker/Caddyfile /etc/caddy/Caddyfile

WORKDIR /srv

RUN mkdir /repos \
    && git init --bare /repos/docker-slides.git \
    && touch /repos/docker-slides.git/git-daemon-export-ok \
    && cd app \
    && git init \
    && git config user.email "me@aligator.dev" \
    && git config user.name "aligator" \
    && git add . \
    && git commit -m "Initial containerized commit" \
    && git push --force /repos/docker-slides.git master \
    && rm -rf .git

