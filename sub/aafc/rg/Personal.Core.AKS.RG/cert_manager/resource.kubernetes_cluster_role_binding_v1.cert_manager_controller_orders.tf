resource "kubernetes_cluster_role_binding_v1" "cert_manager_controller_orders" {
  metadata {
    name = "cert-manager-controller-orders"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role_v1.cert_manager_controller_orders.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.cert_manager.metadata[0].name
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }
}
