#!/bin/bash

echo "PAServer Password: securepass"
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it -e PA_SERVER_PASSWORD=securepass -p 64211:64211 -p 8082:8082 radstudio/paserver:latest
