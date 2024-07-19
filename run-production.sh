#!/usr/bin/env bash

if [ "$1" = '' ]; then
    echo "RAD Server Docker paserver Run Script";
    echo "Required arguments: PAServer password";
    echo "ex: run-production.sh securepass";
else
    docker run --platform linux/amd64 \
          -d -t -e PA_SERVER_PASSWORD=$1 \
          -p 64211:64211 \
          --name paserver \
          radstudio/paserver:latest
fi
