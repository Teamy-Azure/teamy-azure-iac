resource "kubernetes_cluster_role_v1" "cert_manager_edit" {
  metadata {
    name = "cert-manager-edit"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "rbac.authorization.k8s.io/aggregate-to-edit" = "true", "rbac.authorization.k8s.io/aggregate-to-admin" = "true", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers"]
    verbs = ["create", "delete", "deletecollection", "patch", "update"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates/status"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges"]
    verbs = ["delete", "deletecollection", "patch", "update"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["orders"]
    verbs = ["delete", "deletecollection"]
  }
}
