resource "kubernetes_config_map_v1" "traefik" {
  metadata {
    name = "traefik"
    namespace = kubernetes_namespace_v1.traefik.metadata[0].name
  }
  data = {
    "traefik.yaml" = yamlencode({
      global = { checkNewVersion = false, sendAnonymousUsage = false }
      api = { dashboard = false, insecure = false }
      ping = { entryPoint = "traefik" }
      log = { level = "INFO", format = "json" }
      accessLog = { format = "json" }
      entryPoints = {
        traefik = { address = ":8080/tcp", http = { aliasHeadersStrategy = "delete" } }
        web = { address = ":8000/tcp", http = { aliasHeadersStrategy = "delete" } }
        websecure = { address = ":8443/tcp", http = { aliasHeadersStrategy = "delete" } }
      }
      providers = {
        kubernetesIngress = {
          ingressClass = "traefik"
          ingressEndpoint = { publishedService = "traefik/traefik" }
          allowExternalNameServices = false
        }
        kubernetesCRD = {
          allowCrossNamespace = false
          allowExternalNameServices = false
          safeNaming = false
        }
      }
    })
  }
}
