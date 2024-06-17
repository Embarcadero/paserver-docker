#!/bin/bash

docker build . \
        --build-arg password=securepass \
        --platform linux/amd64 \
	--tag=radstudio/paserver:latest \
	--tag=radstudio/paserver:athens \
	--tag=radstudio/paserver:12.1.1 \
