#!/bin/bash
set -xe

cd /home/dholler/repos/github.com/dominikholler/kubevirt-renovate

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



buildah build --pull=always --build-arg BAZEL_VERSION=6.5.0 --format docker -t kubevirt-renovate-bazel-650

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
    -e RENOVATE_BASE_BRANCH_PATTERNS='["main", "release-1.7"]' \
    localhost/kubevirt-renovate-bazel-650


buildah build --pull=always --build-arg BAZEL_VERSION=5.4.1 --format docker -t kubevirt-renovate-bazel-541
podman run --rm -it \
    -e RENOVATE_FORK_TOKEN=$GITHUB_PAT \
    -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN \
    -e RENOVATE_REPOSITORIES=$REPO \
    -e LOG_LEVEL=$LOG_LEVEL \
    -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make deps-update"]' \
    -e RENOVATE_CONFIG="$(< kubevirt-renovate.json)" \
    -e RENOVATE_ONBOARDING=false \
    -e RENOVATE_REQUIRE_CONFIG=optional \
    -e RENOVATE_BASE_BRANCH_PATTERNS='["release-1.6"]' \
    localhost/kubevirt-renovate-bazel-541

podman run --rm -it \
    -e RENOVATE_FORK_TOKEN=$GITHUB_PAT \
    -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN \
    -e RENOVATE_REPOSITORIES=$REPO \
    -e LOG_LEVEL=$LOG_LEVEL \
    -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make deps-update"]' \
    -e RENOVATE_CONFIG="$(< kubevirt-renovate-no-workspace.json)" \
    -e RENOVATE_ONBOARDING=false \
    -e RENOVATE_REQUIRE_CONFIG=optional \
    localhost/kubevirt-renovate-bazel-541






