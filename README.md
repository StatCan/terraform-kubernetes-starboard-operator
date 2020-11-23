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
  source = "github.com/canada-ca-terraform-modules/terraform-kubernetes-aquasecurity?ref=v2.0.0"

  dependencies = [
    module.namespace_starboard_operator.depended_on,
  ]

  helm_namespace = kubernetes_namespace.starboard_operator.name
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
| 20200825 | v1.0.0     | Default of Starboard                                       |
| 20201123 | v2.0.0     | Switch to Starboard Operator w/ Helm Chart                 |
