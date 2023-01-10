#!/bin/bash

docker build . --build-arg password=securepass --tag=radstudio/paserver:11.2 \
    --tag=radstudio/paserver:alexandria --tag=radstudio/paserver:latest