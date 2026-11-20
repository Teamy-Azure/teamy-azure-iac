resource "kubernetes_service_v1" "traefik" {
  metadata {
    name = "traefik"
    namespace = kubernetes_namespace_v1.traefik.metadata[0].name
    annotations = { "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz" }
  }
  wait_for_load_balancer = true
  spec {
    type = "LoadBalancer"
    external_traffic_policy = "Local"
    selector = { "app.kubernetes.io/name" = "traefik" }
    port {
      name = "web"
      protocol = "TCP"
      port = 80
      target_port = "web"
    }
    port {
      name = "websecure"
      protocol = "TCP"
      port = 443
      target_port = "websecure"
    }
  }
  depends_on = [kubernetes_deployment_v1.traefik]
  timeouts {
    create = "10m"
  }
}
