#!/bin/bash

docker build . --build-arg password=securepass \
	--tag=radstudio/paserver:athens \
	--tag=radstudio/paserver:12.0 \
