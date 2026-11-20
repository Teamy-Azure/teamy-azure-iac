resource "kubernetes_cluster_role_v1" "cert_manager_controller_challenges" {
  metadata {
    name = "cert-manager-controller-challenges"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges", "challenges/status"]
    verbs = ["update", "patch"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["issuers", "clusterissuers"]
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
    verbs = ["create", "patch"]
  }
  rule {
    api_groups = [""]
    resources = ["pods", "services"]
    verbs = ["get", "list", "watch", "create", "delete"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch", "create", "delete", "update"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["httproutes"]
    verbs = ["get", "list", "watch", "create", "delete", "update"]
  }
  rule {
    api_groups = ["route.openshift.io"]
    resources = ["routes/custom-host"]
    verbs = ["create"]
  }
  rule {
    api_groups = ["acme.cert-manager.io"]
    resources = ["challenges/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "list", "watch"]
  }
}
