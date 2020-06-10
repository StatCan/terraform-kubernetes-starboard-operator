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
  source = "github.com/canada-ca-terraform-modules/terraform-kubernetes-aquasecurity?ref=20200610.1"

  dependencies = []
}
```

## Variables Values

| Name                    | Type   | Required | Value                                                  |
| ----------------------- | ------ | -------- | ------------------------------------------------------ |
| dependencies            | list   | yes      | Dependency name refering to namespace module           |

## History

| Date     | Release    | Change                                                     |
| -------- | ---------- | ---------------------------------------------------------- |
| 20200610 | 20200610.1 | 1st release                                                |
