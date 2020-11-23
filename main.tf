# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
# and
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-473091030
# Make sure to add this null_resource.dependency_getter to the `depends_on`
# attribute to all resource(s) that will be constructed first within this
# module:
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.dependencies)}"
  }

  lifecycle {
    ignore_changes = [
      triggers["my_dependencies"],
    ]
  }
}

resource "helm_release" "starboard_operator" {
  depends_on = [null_resource.dependency_getter]
  name       = "starboard-operator"

  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password

  chart     = var.chart_name
  version   = var.chart_version
  namespace = var.helm_namespace

  values = [
    var.values,
  ]
}

resource "kubernetes_cron_job" "kube_bench" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "kube-bench"
    namespace = var.starboard_namespace
  }

  spec {
    concurrency_policy            = "Replace"
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 3
    starting_deadline_seconds     = 60
    schedule                      = "0 4 * * *"

    job_template {
      metadata {}
      spec {
        backoff_limit = 0
        template {
          metadata {}
          spec {
            automount_service_account_token = true
            service_account_name            = kubernetes_service_account.starboard.metadata.0.name
            container {
              name    = "starboard"
              image   = "aquasec/starboard:0.6.0"
              command = ["starboard"]
              args    = ["kube-bench", "-v3", "--scan-job-timeout=120s"]
            }
            restart_policy = "Never"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_account" "starboard" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "starboard" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name = "starboard"
  }

  rule {
    api_groups = ["aquasecurity.github.io"]
    resources  = ["ciskubebenchreports"]
    verbs      = ["create", "get", "list", "watch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "get", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "starboard" {
  depends_on = [null_resource.dependency_getter]

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
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "pods/log"]
    verbs      = ["list", "get", "watch"]
  }
}

resource "kubernetes_role_binding" "starboard" {
  depends_on = [null_resource.dependency_getter]

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

resource "kubernetes_config_map" "starboard" {
  depends_on = [null_resource.dependency_getter]

  metadata {
    name      = "starboard"
    namespace = var.starboard_namespace
  }

  data = {
    "trivy.severity"      = "CRITICAL"
    "trivy.imageRef"      = "docker.io/aquasec/trivy:0.12.0"
    "trivy.mode"          = "Standalone"
    "trivy.serverURL"     = "http://trivy-server.trivy-server:4954"
    "kube-bench.imageRef" = "docker.io/aquasec/kube-bench:0.4.0"
  }
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
resource "null_resource" "dependency_setter" {
  # Part of a hack for module-to-module dependencies.
  # https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
  # List resource(s) that will be constructed last within the module.
  depends_on = [
    helm_release.starboard_operator,
  ]
}
