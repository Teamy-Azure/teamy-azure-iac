resource "kubernetes_cluster_role_v1" "traefik" {
  metadata { name = "traefik-ingress-controller" }

  # The Ingress and CRD providers watch these objects in each workload namespace.
  rule {
    api_groups = [""]
    resources = ["services", "secrets", "nodes", "configmaps"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources = ["endpointslices"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses", "ingressclasses"]
    verbs = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses/status"]
    verbs = ["update"]
  }
  rule {
    api_groups = ["traefik.io"]
    resources = [
      "ingressroutes", "ingressroutetcps", "ingressrouteudps", "middlewares",
      "middlewaretcps", "serverstransports", "serverstransporttcps", "tlsoptions",
      "tlsstores", "traefikservices"
    ]
    verbs = ["get", "list", "watch"]
  }
}
