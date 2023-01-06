#!/bin/bash

docker build . --build-arg password=securepass --tag=radstudio/paserver:11.2