resource "kubernetes_cluster_role_v1" "cert_manager_view" {
  metadata {
    name = "cert-manager-view"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "rbac.authorization.k8s.io/aggregate-to-view" = "true", "rbac.authorization.k8s.io/aggregate-to-edit" = "true", "rbac.authorization.k8s.io/aggregate-to-admin" = "true", "rbac.authorization.k8s.io/aggregate-to-cluster-reader" = "true", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges", "orders"]
    verbs = ["get", "list", "watch"]
  }
}
