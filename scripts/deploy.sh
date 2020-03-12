#!/usr/bin/env bash

set -eo pipefail

source scripts/is-release.sh

function deployWineVersion () {
  # https://stackoverflow.com/a/58453200/1123955
  WINE_VERSION=$(
    docker run --rm \
    -a stdout \
    --entrypoint wine \
    "$ARTIFACT_IMAGE" \
    --version | cut -d- -f2   # wine-5.0 -> 5.0
  )

  echo "Deploying WINE_VERSION=$WINE_VERSION"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${WINE_VERSION}"
  docker push "${IMAGE}:${WINE_VERSION}"
}

function deployVersion () {
  SEMVER_MAJOR=$(semver get major "$VERSION")
  SEMVER_MINOR=$(semver get minor "$VERSION")

  TAG="$SEMVER_MAJOR.$SEMVER_MINOR"

  echo "Deploying TAG=$TAG"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:${TAG}"
  docker push "${IMAGE}:${TAG}"
}

function deployLatest () {
  echo "Deploying IMAGE=$IMAGE latest"
  docker tag "${ARTIFACT_IMAGE}" "${IMAGE}:latest"
  docker push "${IMAGE}:latest"
}

function main () {
  if [ -z "$1" ]; then
    >&2 echo -e "Missing argument.\nUsage: $0 ARTIFACT_IMAGE"
    exit 1
  fi

  ARTIFACT_IMAGE=$1

  IMAGE=$(cat IMAGE)
  VERSION=$(cat VERSION)

  deployWineVersion
  deployVersion

  if isRelease "$VERSION"; then
    deployLatest
    echo "$VERSION set to latest"
  fi
}

main "$@"
