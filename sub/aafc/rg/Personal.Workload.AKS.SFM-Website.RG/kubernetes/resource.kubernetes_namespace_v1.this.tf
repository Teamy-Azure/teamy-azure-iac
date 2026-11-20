resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "sfm-website"
    annotations = {
      name = "sfm-website"
    }
  }
}
