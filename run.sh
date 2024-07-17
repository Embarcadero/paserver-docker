#!/usr/bin/env bash

# path binding example: --mount type=bind,source=/home/paserver,target=/root/PAServer/scratch-dir
echo "PAServer Password: securepass"
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --name paserver -e PA_SERVER_PASSWORD=securepass -p 64211:64211 radstudio/paserver:latest
