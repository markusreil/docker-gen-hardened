#!/bin/sh
set -eu

IMAGE="mreil/docker-gen-hardened"
DOCKER_GEN_VERSION="${DOCKER_GEN_VERSION:-0.17.2}"
REVISION="${REVISION:-1}"
VERSION="${DOCKER_GEN_VERSION}-hardened.${REVISION}"
BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cd "$(dirname "$0")"

docker build \
  --build-arg "DOCKER_GEN_VERSION=${DOCKER_GEN_VERSION}" \
  --build-arg "BUILD_DATE=${BUILD_DATE}" \
  -t "${IMAGE}:${VERSION}" \
  -t "${IMAGE}:latest" \
  .
