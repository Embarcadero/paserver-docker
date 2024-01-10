#!/bin/bash

if [ "$1" = '' ]; then
    echo "RAD Server Docker paserver Run Script";
    echo "Required arguments: PAServer password";
    echo "ex: run-production.sh securepass";
else
    docker run -d -e PA_SERVER_PASSWORD=$1 -p 64211:64211 -p 8082:8082 radstudio/paserver:11.3
fi
