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
  default = "0.1.0"
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