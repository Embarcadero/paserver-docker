#!/bin/bash

if [ "$1" = '' ]; then
    echo "RAD Server Docker paserver Pull-Run Script";
    echo "Required arguments: PAServer password";
    echo "ex: pull-run-production.sh securepass";
else
    docker pull radstudio/paserver:latest

    bash ./run-production.sh $1
fi
