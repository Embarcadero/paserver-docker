#!/usr/bin/env bash

NAME="paserver"
BIND_PATH=""
VERSION="latest"
PRODUCTION=false
PORT="64211"
DETACH=false
PASSWORD="securepass"

while [ $# -gt 0 ]; do
  case "$1" in
    --name|-n)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if no `=`
      NAME="${1#*=}"
      ;;
    --path|-pa)
      if [[ "$1" != *=* ]]; then shift; fi
      BIND_PATH="${1#*=}"
      ;;
    --detach|-d)
      # if [[ "$1" != *=* ]]; then shift; fi
      DETACH=true
      ;;
    --port|-p)
      if [[ "$1" != *=* ]]; then shift; fi
      PORT="${1#*=}"
      ;;
    --production|-pr)
      # if [[ "$1" != *=* ]]; then shift; fi
      PRODUCTION=true
      ;;
    --version|-v)
      if [[ "$1" != *=* ]]; then shift; fi
      VERSION="${1#*=}"
      ;;
    --password|-pw)
      if [[ "$1" != *=* ]]; then shift; fi
      PASSWORD="${1#*=}"
      ;;
    --help|-h)
      printf "Usage: run.sh [OPTIONS]\n\n"
      printf "Example 1: run.sh --path /home/user/ --detach --port 64211 --production --password securepass --name my-paserver --version latest\n\n"
      printf "Example 2: run.sh -pa /home/user/ -d -p 64211 -pr -pw securepass -n my-paserver -v latest\n\n"
      printf "Options:\n"
      printf "  --name, -n NAME\tSpecify the name of the container - default: ${NAME}\n"
      printf "  --detach, -d\t\tRun in detached mode - default: ${DETACH}\n"
      printf "  --path, -pa\t\tBinds the container to a local folder - default: no bind\n"
      printf "  --port, -p PORT\tSpecify the port to use be used by PAServer - default: ${PORT}\n"
      printf "  --production, -pr\tEnable production mode - default: ${PRODUCTION}\n"
      printf "  --version, -v VERSION\tSpecify the PAServer tag to be used as image - default: ${VERSION}\n"
      printf "  --password, -pw PWD\tSet the password - default: ${PASSWORD}\n"
      printf "  --help, -h\t\tDisplay this help and exit\n"
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument\n"
      exit 1
      ;;
  esac
  shift
done

if [ "$BIND_PATH" != "" ]; then
    BIND_PATH_ARG="--mount type=bind,source=$BIND_PATH,target=/root/PAServer/scratch-dir"
fi

if [ "$DETACH" = true ]; then
    DETACH_ARG="-d -t"
else
    DETACH_ARG="-it"
fi

if [ "$PRODUCTION" = false ]; then
    printf "Password: $PASSWORD\n"
    printf "Port: $PORT\n"
    printf "Detach: $DETACH\n"
    printf "Production: $PRODUCTION\n"
    printf "Path: $BIND_PATH\n"
    printf "Name: $NAME\n"
    printf "Version: $VERSION\n"

    DEBUG_ARG="--cap-add=SYS_PTRACE --security-opt seccomp=unconfined"
fi

docker run $DEBUG_ARG \
           $DETACH_ARG \
           -e PA_SERVER_PASSWORD=$PASSWORD \
           $BIND_PATH_ARG \
           --name $NAME \
           -p $PORT:64211 radstudio/paserver:$VERSION