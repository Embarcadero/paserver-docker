#!/bin/bash

docker build . --build-arg password=securepass \
	--tag=radstudio/paserver:alexandria \
	--tag=radstudio/paserver:11.3
