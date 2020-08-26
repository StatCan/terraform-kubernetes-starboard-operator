# Terraform Kubernetes Aqua Security

## Introduction

This module deploys parts of the [Aqua Security Stack](https://github.com/aquasecurity).

## Security Controls

The following security controls can be met through configuration of this template:

* TBD

## Dependencies

* None

## Optional (depending on options configured):

* None

## Usage

```terraform
module "kubectl_aquasecurity" {
  source = "github.com/canada-ca-terraform-modules/terraform-kubernetes-aquasecurity?ref=v1.0.0"

  dependencies = [
    "${module.namespace_starboard.depended_on}",
  ]

  kubectl_namespace = "${module.namespace_starboard.name}"
}
```

## Variables Values

| Name                    | Type   | Required | Value                                                  |
| ----------------------- | ------ | -------- | ------------------------------------------------------ |
| dependencies            | list   | yes      | Dependency name refering to namespace module           |
| kubectl_namespace       | list   | yes      | The namespace kubectl will install the manifests under |

## History

| Date     | Release    | Change                                                     |
| -------- | ---------- | ---------------------------------------------------------- |
| 20200825 | v1.0.0     | Default of Kubebench                                       |
