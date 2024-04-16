#!/bin/bash

docker build . --build-arg password=securepass \
	--tag=radstudio/paserver:latest \
	--tag=radstudio/paserver:athens \
	--tag=radstudio/paserver:12.1 \
