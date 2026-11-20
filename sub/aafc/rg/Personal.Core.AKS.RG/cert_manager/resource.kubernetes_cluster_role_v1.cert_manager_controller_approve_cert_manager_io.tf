resource "kubernetes_cluster_role_v1" "cert_manager_controller_approve_cert_manager_io" {
  metadata {
    name = "cert-manager-controller-approve:cert-manager-io"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cert-manager", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["signers"]
    verbs = ["approve"]
    resource_names = ["issuers.cert-manager.io/*", "clusterissuers.cert-manager.io/*"]
  }
}
