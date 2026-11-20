resource "kubernetes_cluster_role_v1" "cert_manager_controller_certificatesigningrequests" {
  metadata {
    name = "cert-manager-controller-certificatesigningrequests"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cert-manager", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["certificatesigningrequests"]
    verbs = ["get", "list", "watch", "update"]
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["certificatesigningrequests/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["certificates.k8s.io"]
    resources = ["signers"]
    resource_names = ["issuers.cert-manager.io/*", "clusterissuers.cert-manager.io/*"]
    verbs = ["sign"]
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources = ["subjectaccessreviews"]
    verbs = ["create"]
  }
}
