resource "kubernetes_cluster_role_binding_v1" "traefik" {
  metadata { name = "traefik-ingress-controller" }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role_v1.traefik.metadata[0].name
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.traefik.metadata[0].name
    namespace = kubernetes_namespace_v1.traefik.metadata[0].name
  }
}
