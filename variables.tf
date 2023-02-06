variable "helm_namespace" {
  default = "starboard-operator"
}

variable "helm_repository" {
  default     = "https://aquasecurity.github.io/helm-charts/"
  description = "The repository where the Helm chart is stored"
}

variable "helm_repository_password" {
  type        = string
  nullable    = false
  default     = ""
  description = "The password of the repository where the Helm chart is stored"
  sensitive   = true
}
variable "helm_repository_username" {
  type        = string
  nullable    = false
  default     = ""
  description = "The username of the repository where the Helm chart is stored"
  sensitive   = true
}

variable "chart_name" {
  default = "starboard-operator"
}

variable "chart_version" {
  default = "0.10.1"
}

variable "cron_job_suspend" {
  default = "false"
}

variable "image_pull_secrets" {
  type    = list(string)
  default = []
}

variable "image_registry" {
  default = "docker.io"
}

variable "image_tag" {
  default = "0.15.1"
}

variable "starboard_namespace" {
  default = "starboard-system"
}

variable "trivy_mode" {
  default = "Standalone"
}

variable "trivy_server_url" {
  default = "http://trivy-server.trivy-server:4954"
}

variable "trivy_severity" {
  default = "CRITICAL"
}

variable "server_token_header" {
  default = ""
}

variable "values" {
  default = ""
}
