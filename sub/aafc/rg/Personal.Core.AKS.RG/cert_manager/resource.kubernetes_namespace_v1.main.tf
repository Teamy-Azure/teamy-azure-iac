resource "kubernetes_namespace_v1" "main" {
  metadata {
    name = "cert-manager"
    labels = { "app.kubernetes.io/managed-by" = "Terraform" }
  }
}
