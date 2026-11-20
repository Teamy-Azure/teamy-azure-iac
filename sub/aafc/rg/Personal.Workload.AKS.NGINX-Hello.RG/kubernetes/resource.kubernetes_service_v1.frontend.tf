resource "kubernetes_service_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.hello.metadata[0].name
  }
  spec {
    selector = local.selector
    type = "LoadBalancer"
    port {
      port = 80
      target_port = 80
    }
  }
}
