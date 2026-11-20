resource "kubernetes_service_account_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  automount_service_account_token = true
}
