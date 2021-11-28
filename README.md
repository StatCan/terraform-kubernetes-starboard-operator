# Terraform Kubernetes Aqua Security

## Introduction

This module deploys parts of the [Aqua Security Stack](https://github.com/aquasecurity).

## Security Controls

The following security controls can be met through configuration of this template:

- TBD

## Dependencies

- None

## Usage

```terraform
module "helm_aquasecurity" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-aquasecurity.git?ref=v3.0.0"

  depends_on = [
    module.namespace_starboard_operator,
    module.namespace_starboard,
  ]

  helm_namespace           = kubernetes_namespace.starboard_operator.id
  helm_repository          = "https://artifactory.example.ca/artifactory/helm-remote"
  helm_repository_username = var.docker_username
  helm_repository_password = var.docker_password

  starboard_namespace = kubernetes_namespace.starboard.id

  image_registry     = "artifactory.example.ca/docker-remote"
  image_pull_secrets = ["artifactory"]

  trivy_mode       = "ClientServer"
  trivy_server_url = "https://trivy.dev.example.ca"

  values = <<EOF

EOF
}

```

## Variables Values

| Name                     | Type         | Required | Value                                            |
| ------------------------ | ------------ | -------- | ------------------------------------------------ |
| helm_namespace           | string       | yes      | The operator namespace                           |
| helm_repository          | string       | yes      | The helm repository                              |
| helm_repository_password | string       | yes      | The helm repository password                     |
| helm_repository_username | string       | yes      | The helm repository username                     |
| chart_name               | string       | yes      | The chart name                                   |
| chart_version            | string       | yes      | The chart version                                |
| cron_job_suspend         | string       | yes      | Whether to supsend the cronjob                   |
| image_pull_secrets       | list(string) | yes      | A list of image pull secrets                     |
| image_registry           | string       | yes      | The image registory for the operator             |
| image_tag                | string       | yes      | The image tag for the operator                   |
| starboard_namespace      | string       | yes      | The starboard namespace                          |
| trivy_mode               | string       | yes      | The Trivy mode                                   |
| trivy_server_url         | string       | yes      | The Trivy server url                             |
| trivy_severity           | string       | yes      | The Trivy severity                               |
| server_token_header      | string       | yes      | The Trivy server token header                    |
| values                   | string       | yes      | Additional values to be passed to the helm chart |

## History

| Date     | Release | Change                                     |
| -------- | ------- | ------------------------------------------ |
| 20211128 | v3.0.0  | Better integration with Helm Chart         |
| 20201123 | v2.0.0  | Switch to Starboard Operator w/ Helm Chart |
| 20200825 | v1.0.0  | Default of Starboard                       |
