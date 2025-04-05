#!/usr/bin/env bash
docker build -t slides-app .
docker run --rm -ti -v ./presentation.md:/presentations/presentation.md slides-app 