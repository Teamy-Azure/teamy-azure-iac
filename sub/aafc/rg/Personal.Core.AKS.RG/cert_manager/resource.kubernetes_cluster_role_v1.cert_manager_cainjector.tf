resource "kubernetes_cluster_role_v1" "cert_manager_cainjector" {
  metadata {
    name = "cert-manager-cainjector"
    labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["get", "create", "update", "patch"]
  }
  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["apiregistration.k8s.io"]
    resources = ["apiservices"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources = ["customresourcedefinitions"]
    verbs = ["get", "list", "watch", "update", "patch"]
  }
}
