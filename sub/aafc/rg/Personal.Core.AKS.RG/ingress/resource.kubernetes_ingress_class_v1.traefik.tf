resource "kubernetes_ingress_class_v1" "traefik" {
  metadata {
    name = "traefik"
    annotations = { "ingressclass.kubernetes.io/is-default-class" = "false" }
  }
  spec { controller = "traefik.io/ingress-controller" }
}
