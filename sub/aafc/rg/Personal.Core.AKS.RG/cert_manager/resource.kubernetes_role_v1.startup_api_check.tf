resource "kubernetes_role_v1" "startup_api_check" {
  metadata {
    name = "cert-manager-startupapicheck:create-cert"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificaterequests"]
    verbs = ["create"]
  }
}
