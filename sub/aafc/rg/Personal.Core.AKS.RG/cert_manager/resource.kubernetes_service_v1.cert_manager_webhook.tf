resource "kubernetes_service_v1" "cert_manager_webhook" {
  metadata {
    name = "cert-manager-webhook"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  spec {
    type = "ClusterIP"
    selector = { "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook" }
    port {
      name = "https"
      protocol = "TCP"
      port = 443
      target_port = "https"
    }
    port {
      name = "metrics"
      protocol = "TCP"
      port = 9402
      target_port = "http-metrics"
    }
  }
}
