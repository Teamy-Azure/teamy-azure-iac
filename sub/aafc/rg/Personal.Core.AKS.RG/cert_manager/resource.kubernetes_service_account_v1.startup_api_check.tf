resource "kubernetes_service_account_v1" "startup_api_check" {
  metadata {
    name = "cert-manager-startupapicheck"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app.kubernetes.io/managed-by" = "Terraform" }
  }
  automount_service_account_token = true
}
