resource "kubernetes_service_account" "starboard_operator" {
  metadata {
    name      = "starboard-operator"
    namespace = var.helm_namespace
  }

  automount_service_account_token = true

  dynamic "image_pull_secret" {
    for_each = var.image_pull_secrets
    content {
      name = image_pull_secret.value
    }
  }
}

resource "kubernetes_service_account" "starboard" {
  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  automount_service_account_token = true

  dynamic "image_pull_secret" {
    for_each = var.image_pull_secrets
    content {
      name = image_pull_secret.value
    }
  }
}
