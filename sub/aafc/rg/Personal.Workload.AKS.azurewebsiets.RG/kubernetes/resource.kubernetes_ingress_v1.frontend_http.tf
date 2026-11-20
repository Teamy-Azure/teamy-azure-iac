resource "kubernetes_ingress_v1" "frontend_http" {
  metadata {
    name = "frontend-http"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      "traefik.ingress.kubernetes.io/router.middlewares" = format("%s-https-redirect@kubernetescrd", kubernetes_namespace_v1.this.metadata[0].name)
    }
  }
  spec {
    ingress_class_name = "traefik"
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
                port { number = 80 }
              }
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_manifest.https_redirect]
}
