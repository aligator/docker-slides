#!/usr/bin/env bash
docker build -t slides-app .
docker run --rm -ti -v ./slides:/slides slides-app "$@"