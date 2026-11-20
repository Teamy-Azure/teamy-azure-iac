resource "kubernetes_ingress_v1" "http_redirect" {
  metadata {
    name = "frontend-http"
    namespace = data.kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      "traefik.ingress.kubernetes.io/router.middlewares" = "teamy-github-readme-stats-https-redirect@kubernetescrd"
    }
  }
  spec {
    ingress_class_name = "traefik"
    rule {
      host = "github-readme-stats.teamdman.ca"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "frontend"
              port { number = 80 }
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_manifest.https_redirect]
}
