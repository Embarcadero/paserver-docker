#!/bin/bash

docker build . --build-arg password=securepass --tag=radstudio/paserver:10.4.2
