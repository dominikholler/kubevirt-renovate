#!/bin/bash
set -xe

cd /home/dholler/repos/github/dominikholler/kubevirt-renovate

GITHUB_PAT=
GITHUB_AUTHOR_TOKEN=
LOG_LEVEL=INFO

podman run --rm -it --pull=always \
    -e RENOVATE_FORK_TOKEN=$GITHUB_PAT \
    -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN \
    -e RENOVATE_REPOSITORIES=kubevirt/ssp-operator \
    -e LOG_LEVEL=$LOG_LEVEL  \
    -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make vendor", "make generate", "make manifests", "make fmt"]' \
    -e RENOVATE_CONFIG="$(< ssp-renovate.json)" \
    -e RENOVATE_ONBOARDING=false  \
    ghcr.io/renovatebot/renovate


buildah build --pull=always  --format docker -t kubevirt-renovate

REPO=kubevirt/kubevirt
#REPO=tmp-kv-mirror/kubevirttest

podman run --rm -it \
    -e RENOVATE_FORK_TOKEN=$GITHUB_PAT \
    -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN \
    -e RENOVATE_REPOSITORIES=$REPO \
    -e LOG_LEVEL=$LOG_LEVEL \
    -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make deps-update"]' \
    -e RENOVATE_CONFIG="$(< kubevirt-renovate.json)" \
    -e RENOVATE_ONBOARDING=false \
    -e RENOVATE_REQUIRE_CONFIG=optional \
    localhost/kubevirt-renovate

podman run --rm -it \
    -e RENOVATE_FORK_TOKEN=$GITHUB_PAT \
    -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN \
    -e RENOVATE_REPOSITORIES=$REPO \
    -e LOG_LEVEL=$LOG_LEVEL \
    -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make deps-update"]' \
    -e RENOVATE_CONFIG="$(< kubevirt-renovate-no-workspace.json)" \
    -e RENOVATE_ONBOARDING=false \
    -e RENOVATE_REQUIRE_CONFIG=optional \
    localhost/kubevirt-renovate






