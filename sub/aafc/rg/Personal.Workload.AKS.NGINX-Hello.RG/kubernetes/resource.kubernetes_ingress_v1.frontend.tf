resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.hello.metadata[0].name
  }
  spec {
    ingress_class_name = "traefik"
    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}
