resource "kubernetes_config_map_v1" "nginx_conf" {
  metadata {
    name = "nginx-conf"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  data = {
    "nginx.conf" = file(format("%s/nginx.conf", path.module))
  }
}
