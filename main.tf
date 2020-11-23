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
  metadata {
    name      = "kube-bench"
    namespace = var.helm_namespace
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
            container {
              name    = "starboard"
              image   = "aquasec/starboard:0.6.0"
              command = ["starboard"]
              args    = ["kube-bench", "-v3"]
            }
            restart_policy = "Never"
          }
        }
      }
    }
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
