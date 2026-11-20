resource "kubernetes_cluster_role_v1" "cert_manager_cluster_view" {
  metadata {
    name = "cert-manager-cluster-view"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "rbac.authorization.k8s.io/aggregate-to-cluster-reader" = "true", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
}
