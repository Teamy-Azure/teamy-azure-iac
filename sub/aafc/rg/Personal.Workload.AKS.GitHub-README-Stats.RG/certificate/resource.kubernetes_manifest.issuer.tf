resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Issuer"
    metadata = {
      name = local.issuer_name
      namespace = data.kubernetes_namespace_v1.this.metadata[0].name
    }
    spec = {
      acme = {
        email = "TeamDman9201@gmail.com"
        server = var.acme_server
        privateKeySecretRef = { name = local.issuer_name }
        solvers = [{ http01 = { ingress = { ingressClassName = "traefik" } } }]
      }
    }
  }
}
