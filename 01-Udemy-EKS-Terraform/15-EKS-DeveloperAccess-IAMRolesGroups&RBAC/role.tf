# Resource: k8s Role
resource "kubernetes_role_v1" "eksdeveloper_role" {
  metadata {
    name = "${local.name}-eksdeveloper-role"
    namespace = "dev"
  }

  rule {
    api_groups     = ["", "extensions", "apps"]
    resources      = ["*"]
    verbs          = ["*"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["*"]
  }
}