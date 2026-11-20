resource "kubernetes_service_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  spec {
    type = "ClusterIP"
    selector = { app = "teamy-github-readme-stats" }
    port {
      port = 80
      target_port = 8080
    }
  }
}
