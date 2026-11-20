resource "kubernetes_role_binding_v1" "startup_api_check" {
  metadata {
    name = "cert-manager-startupapicheck:create-cert"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app.kubernetes.io/managed-by" = "Terraform" }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role_v1.startup_api_check.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.startup_api_check.metadata[0].name
    namespace = kubernetes_namespace_v1.main.metadata[0].name
  }
}
