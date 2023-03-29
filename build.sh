#!/bin/bash

docker build . --build-arg password=securepass \
	--tag=radstudio/paserver:latest \
	--tag=radstudio/paserver:alexandria \
	--tag=radstudio/paserver:11.3 \
