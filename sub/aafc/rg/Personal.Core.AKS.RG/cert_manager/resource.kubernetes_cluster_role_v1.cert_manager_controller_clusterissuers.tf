resource "kubernetes_cluster_role_v1" "cert_manager_controller_clusterissuers" {
  metadata {
    name = "cert-manager-controller-clusterissuers"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers", "clusterissuers/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}
