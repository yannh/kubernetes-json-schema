#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-standalone-strict - de-referenced schemas, more useful as standalone documents, additionalProperties disallowed
#   X.Y.Z-local - relative references, useful to avoid the network dependency


# All k8s versions, starting from 1.15
K8S_VERSIONS=$(git ls-remote --refs --tags https://github.com/kubernetes/kubernetes.git | cut -d/ -f3 | grep -e '^v1\.[0-9]\{2\}\.[0-9]\{1,2\}$' | grep -v -e  '^v1\.1[0-8]\{1\}' )
OPENAPI2JSONSCHEMABIN="docker run -i -v ${PWD}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

if [ -n "${K8S_VERSION_PREFIX}" ]; then
  export K8S_VERSIONS=$(git ls-remote --refs --tags https://github.com/kubernetes/kubernetes.git | cut -d/ -f3 | grep -e '^'${K8S_VERSION_PREFIX} | grep -e '^v1\.[0-9]\{2\}\.[0-9]\{1,2\}$')
fi

for K8S_VERSION in $K8S_VERSIONS master; do
  SCHEMA=https://raw.githubusercontent.com/kubernetes/kubernetes/${K8S_VERSION}/api/openapi-spec/swagger.json
  PREFIX=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/${K8S_VERSION}/_definitions.json

  if [ ! -d "${K8S_VERSION}-standalone-strict" ]; then
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-standalone-strict" --expanded --kubernetes --stand-alone --strict "${SCHEMA}"
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-standalone-strict" --kubernetes --stand-alone --strict "${SCHEMA}"
  fi

  if [ ! -d "${K8S_VERSION}-standalone" ]; then
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-standalone" --expanded --kubernetes --stand-alone "${SCHEMA}"
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-standalone" --kubernetes --stand-alone "${SCHEMA}"
  fi

  if [ ! -d "${K8S_VERSION}-local" ]; then
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-local" --expanded --kubernetes "${SCHEMA}"
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}-local" --kubernetes "${SCHEMA}"
  fi

  if [ ! -d "${K8S_VERSION}" ]; then
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}" --expanded --kubernetes --prefix "${PREFIX}" "${SCHEMA}"
    $OPENAPI2JSONSCHEMABIN -o "schemas/${K8S_VERSION}" --kubernetes --prefix "${PREFIX}" "${SCHEMA}"
  fi
done
