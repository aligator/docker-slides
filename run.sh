#!/usr/bin/env bash

docker build -t slides-app -f ./docker/slides.Dockerfile .
docker run --rm -ti -v ./slides:/slides \
    -e SLIDE_PROTOCOL="${SLIDE_PROTOCOL}" \
    -e SLIDE_HOST="${SLIDE_HOST}" \
    -e SLIDE_PORT="${SLIDE_PORT}" \
    --entrypoint "slides" \
    slides-app "${2:-level1.md}"