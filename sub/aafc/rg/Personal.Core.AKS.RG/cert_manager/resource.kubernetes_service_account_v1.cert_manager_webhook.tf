resource "kubernetes_service_account_v1" "cert_manager_webhook" {
  metadata {
    name = "cert-manager-webhook"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  automount_service_account_token = true
}
