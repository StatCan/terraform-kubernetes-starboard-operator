resource "kubernetes_cluster_role" "starboard" {
  metadata {
    name = "starboard"
  }

  rule {
    api_groups = ["aquasecurity.github.io"]
    resources  = ["ciskubebenchreports"]
    verbs      = ["create", "get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["create", "get", "list", "watch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "get", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "starboard" {
  metadata {
    name = "starboard"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.starboard.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.starboard.metadata.0.name
    namespace = kubernetes_service_account.starboard.metadata.0.namespace
  }
}

resource "kubernetes_role" "starboard" {
  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "pods/log", "secrets"]
    verbs      = ["list", "get", "watch"]
  }
}

resource "kubernetes_role_binding" "starboard" {
  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.starboard.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.starboard.metadata.0.name
    namespace = kubernetes_service_account.starboard.metadata.0.namespace
  }
}
