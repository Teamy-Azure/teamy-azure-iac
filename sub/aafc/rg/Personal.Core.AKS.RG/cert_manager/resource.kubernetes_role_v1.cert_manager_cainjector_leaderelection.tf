resource "kubernetes_role_v1" "cert_manager_cainjector_leaderelection" {
  metadata {
    name = "cert-manager-cainjector:leaderelection"
    namespace = "kube-system"
    labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    resource_names = ["cert-manager-cainjector-leader-election", "cert-manager-cainjector-leader-election-core"]
    verbs = ["get", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }
}
