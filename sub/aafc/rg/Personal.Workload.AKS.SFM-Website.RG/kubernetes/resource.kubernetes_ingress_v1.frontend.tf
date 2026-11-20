resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
      "cert-manager.io/issuer" = "letsencrypt-prod"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "traefik.ingress.kubernetes.io/router.tls" = "true"
    }
  }
  spec {
    ingress_class_name = "traefik"
    tls {
      hosts = local.ingress_hosts
      secret_name = "sfm-website-tls"
    }
    dynamic "rule" {
      for_each = toset(local.ingress_hosts)
      content {
        host = rule.value
        http {
          path {
            path = "/"
            path_type = "Prefix"
            backend {
              service {
                name = kubernetes_service_v1.frontend.metadata[0].name
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }
}
