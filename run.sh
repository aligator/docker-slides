#!/usr/bin/env bash
docker build -t slides-app -f ./docker/slides.Dockerfile .
docker run --rm -ti -v ./slides:/slides slides-app "$@"