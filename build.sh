#!/usr/bin/env bash

# Exit script on error
set -e

# Release identity. Update these when a new RAD Studio version ships.
# RELEASE_PATH is the CDN folder. It is not always the product version with the
# dot removed (for example 12.2 lived under 122/1221/).
PRODUCT_VERSION="13.2"
CODE_NAME="florence"
COMPILER_VERSION="37.0"
RELEASE_PATH="132"

IMAGE_NAME="radstudio/paserver"
PA_SERVER_URL="https://altd.embarcadero.com/releases/studio/${COMPILER_VERSION}/${RELEASE_PATH}/LinuxPAServer${COMPILER_VERSION}.tar.gz"
TARBALL="LinuxPAServer${COMPILER_VERSION}.tar.gz"

if [ "${1:-}" = "beta" ]; then
    # A beta can be the next major, with a new PAServer version in the filename.
    # Pick up whatever archive is in bin/ instead of the release compiler version.
    shift
    if [ "${1:-}" = "--file" ]; then
        TARBALL="${2:-}"
        shift 2
    else
        shopt -s nullglob
        found=(bin/LinuxPAServer*.tar.gz)
        shopt -u nullglob
        if [ ${#found[@]} -eq 1 ]; then
            TARBALL="$(basename "${found[0]}")"
        elif [ ${#found[@]} -eq 0 ]; then
            echo "Place one LinuxPAServer tarball in bin/." >&2
            echo "example: bin/LinuxPAServer38.0.tar.gz" >&2
            exit 1
        else
            echo "bin/ has more than one PAServer archive. Name one with --file." >&2
            printf '  %s\n' "${found[@]##*/}" >&2
            exit 1
        fi
    fi

    if [ $# -lt 1 ] || [ -z "${TARBALL}" ]; then
        echo "usage: ./build.sh beta [--file NAME] <tag> [extra-tag...]" >&2
        echo "example: ./build.sh beta 14.0-beta.1 14.0-beta" >&2
        exit 1
    fi
    if [ ! -f "bin/${TARBALL}" ]; then
        echo "Missing bin/${TARBALL}" >&2
        exit 1
    fi
    PA_SERVER_SOURCE="local"
    TAGS=("$@")
else
    PA_SERVER_SOURCE="remote"
    TAGS=("latest" "${CODE_NAME}" "${PRODUCT_VERSION}")
fi

PRIMARY_TAG="${TAGS[0]}"

# Build the Docker image with the first tag
docker build . \
        --build-arg PA_SERVER_SOURCE="${PA_SERVER_SOURCE}" \
        --build-arg PA_SERVER_URL="${PA_SERVER_URL}" \
        --build-arg PA_SERVER_TARBALL="${TARBALL}" \
        --platform linux/amd64 \
        --pull \
        -t "${IMAGE_NAME}:${PRIMARY_TAG}"

# Tag the built image with additional version tags
for tag in "${TAGS[@]:1}"; do
    docker tag "${IMAGE_NAME}:${PRIMARY_TAG}" "${IMAGE_NAME}:${tag}"
done

# Echo a success message
echo "Docker image ${IMAGE_NAME} tagged with ${TAGS[*]}"
