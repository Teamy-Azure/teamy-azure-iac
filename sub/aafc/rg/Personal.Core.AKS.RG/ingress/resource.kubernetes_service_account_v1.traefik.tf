resource "kubernetes_service_account_v1" "traefik" {
  metadata {
    name = "traefik"
    namespace = kubernetes_namespace_v1.traefik.metadata[0].name
  }
  automount_service_account_token = true
}
