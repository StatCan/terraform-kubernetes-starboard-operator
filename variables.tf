variable "helm_namespace" {
  default = "starboard-operator"
}

variable "helm_repository" {
  default = "https://statcan.github.io/charts"
}

variable "helm_repository_password" {
  default = ""
}
variable "helm_repository_username" {
  default = ""
}

variable "chart_name" {
  default = "starboard-operator"
}

variable "chart_version" {
  default = "0.3.0"
}

variable "dependencies" {
  type = list(any)
}

variable "values" {
  default = ""
}

variable "starboard_namespace" {
  default = "starboard"
}

variable "image_pull_secrets" {
  type    = list(string)
  default = []
}

variable "image_registry" {
  default = "docker.io"
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
