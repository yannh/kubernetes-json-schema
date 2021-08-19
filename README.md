# Kubernetes JSON Schemas

## Fork

This is a fork from [instrumenta/kubernetes-json-schema](https://github.com/instrumenta/kubernetes-json-schema)
with updated scripts for easier maintenance, as well as schemas for all recent
Kubernetes versions.

This repository is kept up-to-date automatically every day using Github Actions.


## Usage

### Kubeconform

This is the default schema repository used by [Kubeconform](https://github.com/yannh/kubeconform), and does not
need to be specified. When using multiple schema repositories, this repo can be referred to using the alias *default*.

```
# All 3 are equivalent
$ kubeconform deployment.yaml
$ kubeconform -schema-location default deployment.yaml
$ kubeconform -schema-location 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/{{ .NormalizedKubernetesVersion }}-standalone{{ .StrictSuffix }}/{{ .ResourceKind }}{{ .KindSuffix }}.json' deployment.yaml
Summary: 1 resource found in 1 file - Valid: 1, Invalid: 0, Errors: 0, Skipped: 0
```

### Kubeval

```
$ kubeval --strict --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ deployment.yaml
PASS - deployment.yaml contains a valid Deployment
```

To run `kubeval` against a specific Kubernetes version, pass the `-v` argument
```sh
$ kubeval -v 1.19.8 -s  https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master ingress.yaml
PASS - ingress.yaml contains a valid Ingress (ingress)
```

## Building the schemas yourself

The tooling for generating these schemas is [a fork](https://github.com/yannh/openapi2jsonschema)
from the original [openapi2jsonschema](https://github.com/yannh/openapi2jsonschema). See *build.sh*.

It's not Kubernetes specific and should work with other OpenAPI
APIs too. This should be useful if you're using a pre-release or otherwise
modified version of Kubernetes, or something like OpenShift which extends the
standard APIs with additional types.
