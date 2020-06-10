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

resource "null_resource" "starboard_init" {
  triggers = {
    hash_kubebench = filesha256("${path.module}/config/starboard/ciskubebenchreports-crd.yaml"),
    hash_configaudit = filesha256("${path.module}/config/starboard/configauditreports-crd.yaml"),
    hash_kubehunter = filesha256("${path.module}/config/starboard/kubehunterreports-crd.yaml"),
    hash_vulnerabilities = filesha256("${path.module}/config/starboard/vulnerabilities-crd.yaml")
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${"${path.module}/config/starboard/ciskubebenchreports-crd.yaml"}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${"${path.module}/config/starboard/configauditreports-crd.yaml"}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${"${path.module}/config/starboard/kubehunterreports-crd.yaml"}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${"${path.module}/config/starboard/vulnerabilities-crd.yaml"}"
  }

  depends_on = [
    "null_resource.dependency_getter",
  ]
}

# Part of a hack for module-to-module dependencies.
# https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
resource "null_resource" "dependency_setter" {
  # Part of a hack for module-to-module dependencies.
  # https://github.com/hashicorp/terraform/issues/1178#issuecomment-449158607
  # List resource(s) that will be constructed last within the module.
  depends_on = [
    "null_resource.starboard_init",
  ]
}