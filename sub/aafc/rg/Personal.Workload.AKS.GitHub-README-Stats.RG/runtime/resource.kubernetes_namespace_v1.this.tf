resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "teamy-github-readme-stats"
    labels = { "app.kubernetes.io/name" = "teamy-github-readme-stats" }
  }
}
