resource "helm_release" "starboard_operator" {
  name = "starboard-operator"

  repository          = var.helm_repository
  repository_username = var.helm_repository_username
  repository_password = var.helm_repository_password

  chart     = var.chart_name
  version   = var.chart_version
  namespace = var.helm_namespace

  set {
    name  = "targetNamespaces"
    value = ""
  }

  # Service Account

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.starboard_operator.metadata.0.name
  }

  # Operator

  set {
    name  = "operator.replicas"
    value = "1"
  }

  set {
    name  = "operator.leaderElectionId"
    value = "starboard-lock"
  }

  set {
    name  = "operator.logDevMode"
    value = "false"
  }

  set {
    name  = "operator.scanJobTimeout"
    value = "5m"
  }

  set {
    name  = "operator.scanJobsConcurrentLimit"
    value = "5"
  }

  set {
    name  = "operator.scanJobsRetryDelay"
    value = "30s"
  }

  set {
    name  = "operator.vulnerabilityScannerEnabled"
    value = "true"
  }

  set {
    name  = "operator.configAuditScannerEnabled"
    value = "true"
  }

  set {
    name  = "operator.kubernetesBenchmarkEnabled"
    value = "true"
  }

  set {
    name  = "operator.batchDeleteLimit"
    value = "10"
  }

  set {
    name  = "operator.batchDeleteDelay"
    value = "10s"
  }

  # Image

  set {
    name  = "image.repository"
    value = "${var.image_registry}/aquasec/starboard-operator"
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  # Starboard

  set {
    name  = "starboard.vulnerabilityReportsPlugin"
    value = "Trivy"
  }

  set {
    name  = "starboard.configAuditReportsPlugin"
    value = "Polaris"
  }

  set {
    name  = "starboard.scanJobAnnotations"
    value = ""
  }

  # Trivy

  set {
    name  = "trivy.createConfig"
    value = "true"
  }

  set {
    name  = "trivy.imageRef"
    value = "${var.image_registry}/aquasec/trivy:0.20.0"
  }

  set {
    name  = "trivy.mode"
    value = var.trivy_mode
  }

  set {
    name  = "trivy.severity"
    value = "CRITICAL"
  }

  set {
    name  = "trivy.ignoreUnfixed"
    value = "false"
  }

  set {
    name  = "trivy.serverURL"
    value = var.trivy_server_url
  }

  set {
    name  = "trivy.serverTokenHeader"
    value = var.server_token_header
  }

  # Kube Bench

  set {
    name  = "kubeBench.imageRef"
    value = "${var.image_registry}/aquasec/kube-bench:v0.6.5"
  }

  # Polaris

  set {
    name  = "polaris.createConfig"
    value = "false"
  }

  # Conftest

  set {
    name  = "conftest.createConfig"
    value = "false"
  }

  values = [
    <<EOF
image:
  pullPolicy: IfNotPresent
  pullSecrets:
%{for name in var.image_pull_secrets}
    - name: ${name}
%{endfor}

starboard:
  scanJobTolerations: []
EOF
    ,
    var.values,
  ]
}
