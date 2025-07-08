# kubevirt-renovate
This repo contains PoC renovate config for kubevirt.
Renovate can be triggered via
```
buildah build --pull=always  --format docker -t kubevirt-renovate
GITHUB_PAT=...
GITHUB_AUTHOR_TOKEN=...
REPO=kubevirt/kubevirt

podman run --rm -it -e RENOVATE_FORK_TOKEN=$GITHUB_PAT -e RENOVATE_TOKEN=$GITHUB_AUTHOR_TOKEN -e RENOVATE_REPOSITORIES=$REPO -e LOG_LEVEL=debug  -e RENOVATE_ALLOWED_POST_UPGRADE_COMMANDS='["make deps-update"]' -e RENOVATE_CONFIG="$(< kubevirt-renovate.json)" -e RENOVATE_ONBOARDING=false -e RENOVATE_REQUIRE_CONFIG=optional  -e RENOVATE_GIT_AUTHOR="Renovate Bot <renovate@hollyhome.ath.cx>" localhost/kubevirt-renovate
```

