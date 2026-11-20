resource "kubernetes_manifest" "https_redirect" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind = "Middleware"
    metadata = {
      name = "https-redirect"
      namespace = data.kubernetes_namespace_v1.this.metadata[0].name
    }
    spec = {
      redirectScheme = {
        scheme = "https"
        permanent = true
      }
    }
  }
}
