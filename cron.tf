resource "kubernetes_cron_job" "kube_bench" {
  metadata {
    name      = "kube-bench"
    namespace = var.starboard_namespace
  }

  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 3
    schedule                      = "0 20 * * *"
    starting_deadline_seconds     = 60
    successful_jobs_history_limit = 3
    suspend                       = var.cron_job_suspend

    job_template {
      metadata {}
      spec {
        active_deadline_seconds    = 60
        backoff_limit              = 0
        completions                = 1
        manual_selector            = false
        parallelism                = 1
        ttl_seconds_after_finished = 60

        template {
          metadata {}
          spec {
            automount_service_account_token = true
            service_account_name            = kubernetes_service_account.starboard.metadata.0.name
            container {
              name    = "starboard"
              image   = "${var.image_registry}/aquasec/starboard:0.8.0"
              command = ["starboard"]
              args    = ["scan", "ciskubebenchreports", "-v3", "--scan-job-timeout=120s"]
            }
            restart_policy = "Never"
          }
        }
      }
    }
  }
}
