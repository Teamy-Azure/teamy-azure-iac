resource "kubernetes_role_v1" "cert_manager_leaderelection" {
  metadata {
    name = "cert-manager:leaderelection"
    namespace = "kube-system"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    resource_names = ["cert-manager-controller"]
    verbs = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }
}
