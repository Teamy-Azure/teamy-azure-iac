resource "kubernetes_service_account_v1" "cert_manager_cainjector" {
  metadata {
    name = "cert-manager-cainjector"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  automount_service_account_token = true
}
