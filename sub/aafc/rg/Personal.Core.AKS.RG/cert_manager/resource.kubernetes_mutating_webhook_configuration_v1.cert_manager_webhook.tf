resource "kubernetes_mutating_webhook_configuration_v1" "cert_manager_webhook" {
  metadata {
    name = "cert-manager-webhook"
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
    annotations = { "cert-manager.io/inject-ca-from-secret" = "cert-manager/cert-manager-webhook-ca" }
  }
  webhook {
    name = "webhook.cert-manager.io"
    admission_review_versions = ["v1"]
    match_policy = "Equivalent"
    timeout_seconds = 30
    failure_policy = "Fail"
    side_effects = "None"
    # AKS adds these exclusions to keep admission webhooks off managed namespaces.
    namespace_selector {
      match_expressions {
        key = "kubernetes.azure.com/managedby"
        operator = "NotIn"
        values = ["aks"]
      }
      match_expressions {
        key = "control-plane"
        operator = "NotIn"
        values = ["true"]
      }
    }
    rule {
      api_groups = ["cert-manager.io"]
      api_versions = ["v1"]
      operations = ["CREATE"]
      resources = ["certificaterequests"]
    }
    client_config {
      service {
        name = kubernetes_service_v1.cert_manager_webhook.metadata[0].name
        namespace = kubernetes_namespace_v1.main.metadata[0].name
        path = "/mutate"
        port = 443
      }
    }
  }
  lifecycle {
    # cainjector rotates this generated trust bundle; all admission policy stays managed.
    ignore_changes = [webhook[0].client_config[0].ca_bundle]
  }
  depends_on = [kubernetes_deployment_v1.cert_manager_webhook, kubernetes_deployment_v1.cert_manager_cainjector]
}
