#!/usr/bin/env bash

# Exit script on error
set -e

# Variables for image name and tags
IMAGE_NAME="radstudio/paserver"
TAG_LATEST="latest"
TAG_VERSION="athens"
TAG_NUMERIC="12.1.1"

# Build the Docker image with the first tag
docker build . \
        --build-arg password=securepass \
        --platform linux/amd64 \
		--pull \
		-t ${IMAGE_NAME}:${TAG_LATEST} \

# Tag the built image with additional version tags
docker tag "${IMAGE_NAME}:${TAG_LATEST}" "${IMAGE_NAME}:${TAG_VERSION}"
docker tag "${IMAGE_NAME}:${TAG_LATEST}" "${IMAGE_NAME}:${TAG_NUMERIC}"

# Echo a success message
echo "Docker image ${IMAGE_NAME} tagged with ${TAG_LATEST}, ${TAG_VERSION}, and ${TAG_NUMERIC}"