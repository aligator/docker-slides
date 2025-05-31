#!/usr/bin/env bash
docker build -t slides-app -f ./docker/slides.Dockerfile .
docker run --rm -ti -v ./slides:/slides \
    -e SOURCE_PROTOCOL="${SOURCE_PROTOCOL}" \
    -e SOURCE_HOST="${SOURCE_HOST}" \
    -e SOURCE_PORT="${SOURCE_PORT}" \
    -e SLIDE1_HOST="${SLIDE1_HOST}" \
    -e SLIDE1_PORT="${SLIDE1_PORT}" \
    -e SLIDE2_HOST="${SLIDE2_HOST}" \
    -e SLIDE2_PORT="${SLIDE2_PORT}" \
    --entrypoint "slides" \
    slides-app "${1:-level.md}"