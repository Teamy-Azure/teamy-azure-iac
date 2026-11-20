resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = data.kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "cert-manager.io/issuer" = local.issuer_name
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "traefik.ingress.kubernetes.io/router.tls" = "true"
    }
  }
  spec {
    ingress_class_name = "traefik"
    tls {
      hosts = ["github-readme-stats.teamdman.ca"]
      secret_name = "github-readme-stats-teamdman-ca-tls"
    }
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
  depends_on = [kubernetes_manifest.issuer]
}
