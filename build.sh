#!/usr/bin/env bash

# Exit script on error
set -e

# Variables for image name and tags
IMAGE_NAME="radstudio/paserver"
TAG_VERSION="athens"
TAG_NUMERIC="12.3"

# Build the Docker image with the first tag
docker build . \
        --build-arg password=securepass \
        --platform linux/amd64 \
		--pull \
		-t ${IMAGE_NAME}:${TAG_NUMERIC} \

# Tag the built image with additional version tags
docker tag "${IMAGE_NAME}:${TAG_NUMERIC}" "${IMAGE_NAME}:${TAG_VERSION}"

# Echo a success message
echo "Docker image ${IMAGE_NAME} tagged with ${TAG_VERSION}, and ${TAG_NUMERIC}"
