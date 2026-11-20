resource "kubernetes_namespace_v1" "traefik" {
  metadata {
    name = "traefik"
    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
}
