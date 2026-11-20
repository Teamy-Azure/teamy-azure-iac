resource "kubernetes_cluster_role_binding_v1" "cert_manager_cainjector" {
  metadata {
    name = "cert-manager-cainjector"
    labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role_v1.cert_manager_cainjector.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.cert_manager_cainjector.metadata[0].name
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }
}
