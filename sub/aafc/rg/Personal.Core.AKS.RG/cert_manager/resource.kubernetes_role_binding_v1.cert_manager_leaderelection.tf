resource "kubernetes_role_binding_v1" "cert_manager_leaderelection" {
  metadata {
    name = "cert-manager:leaderelection"
    namespace = "kube-system"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role_v1.cert_manager_leaderelection.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.cert_manager.metadata[0].name
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }
}
