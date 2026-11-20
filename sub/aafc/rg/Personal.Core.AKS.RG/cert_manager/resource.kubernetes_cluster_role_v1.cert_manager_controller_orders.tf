resource "kubernetes_cluster_role_v1" "cert_manager_controller_orders" {
  metadata {
    name = "cert-manager-controller-orders"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders", "orders/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders", "challenges"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges"]
    verbs = ["create", "delete"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["clusterissuers/finalizers", "issuers/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}
