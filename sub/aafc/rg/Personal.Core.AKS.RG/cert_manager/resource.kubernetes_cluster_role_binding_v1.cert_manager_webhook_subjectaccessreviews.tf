resource "kubernetes_cluster_role_binding_v1" "cert_manager_webhook_subjectaccessreviews" {
  metadata {
    name = "cert-manager-webhook:subjectaccessreviews"
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role_v1.cert_manager_webhook_subjectaccessreviews.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.cert_manager_webhook.metadata[0].name
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }
}
