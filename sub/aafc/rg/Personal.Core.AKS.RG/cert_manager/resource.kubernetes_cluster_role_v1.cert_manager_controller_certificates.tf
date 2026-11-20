resource "kubernetes_cluster_role_v1" "cert_manager_controller_certificates" {
  metadata {
    name = "cert-manager-controller-certificates"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificates/status", "certificaterequests", "certificaterequests/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "clusterissuers", "issuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates/finalizers", "certificaterequests/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders"]
    verbs = ["create", "delete", "get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}
