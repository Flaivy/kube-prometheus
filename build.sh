#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -e
set -x
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

# Make sure to use project tooling
PATH="$(pwd)/tmp/bin:${PATH}"

# Make sure to start with a clean 'manifests' dir
rm -rf manifests
mkdir -p manifests/setup

# Calling gojsontoyaml is optional, but we would like to generate yaml, not json
jsonnet -J vendor -m manifests "prometheus-pvc.jsonnet" | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}

# Make sure to remove json files
find manifests -type f ! -name '*.yaml' -delete
rm -f kustomization


# DELETE IT ALL BY RUNNING
# kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup


# # START IT ALL BY RUNNING
# kubectl apply --server-side -f manifests/setup
# kubectl wait \
#     --for condition=Established \
#     --all CustomResourceDefinition \
#     --namespace=monitoring
# kubectl apply -f manifests/

