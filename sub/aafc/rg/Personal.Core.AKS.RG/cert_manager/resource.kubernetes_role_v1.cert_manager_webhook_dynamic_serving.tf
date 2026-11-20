resource "kubernetes_role_v1" "cert_manager_webhook_dynamic_serving" {
  metadata {
    name = "cert-manager-webhook:dynamic-serving"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    resource_names = ["cert-manager-webhook-ca"]
    verbs = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
}
