#!/usr/bin/env bash
docker build -t slides-app --dockerfile ./docker/slides.Dockerfile .
docker run --rm -ti -v ./slides:/slides slides-app "$@"