resource "kubernetes_cluster_role_v1" "cert_manager_controller_ingress_shim" {
  metadata {
    name = "cert-manager-controller-ingress-shim"
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests"]
    verbs = ["create", "update", "delete"]
  }
  rule {
    api_groups = ["cert-manager.io"]
    resources = ["certificates", "certificaterequests", "issuers", "clusterissuers"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["gateways", "httproutes", "listenersets"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources = ["gateways/finalizers", "httproutes/finalizers", "listenersets/finalizers"]
    verbs = ["update"]
  }
  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}
