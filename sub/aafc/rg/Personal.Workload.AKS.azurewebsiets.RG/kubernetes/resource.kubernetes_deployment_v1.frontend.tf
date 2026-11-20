resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = local.frontend_selector
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.frontend_selector
    }
    template {
      metadata {
        labels = local.frontend_selector
        annotations = {
          "nginx-conf-sha256" = sha256(kubernetes_config_map_v1.nginx_conf.data["nginx.conf"])
        }
      }
      spec {
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        container {
          name = "nginx"
          image = "nginx:stable-alpine@sha256:970364228b1e4f932abc22d321932816782cca8a20b85a77552a7cfe9acfb3b5"
          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu = "250m", memory = "50Mi"
            }
            limits = {
              cpu = "500m", memory = "512Mi"
            }
          }
          volume_mount {
            name = "nginx-conf"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path = "nginx.conf"
          }
          volume_mount {
            name = "site-content"
            mount_path = "/usr/share/nginx/html"
            read_only = true
          }
        }
        volume {
          name = "nginx-conf"
          config_map {
            name = kubernetes_config_map_v1.nginx_conf.metadata[0].name
          }
        }
        volume {
          name = "site-content"
          csi {
            driver = "blob.csi.azure.com"
            read_only = true
            volume_attributes = {
              containerName = "webcontent"
              secretName = kubernetes_secret_v1.storage_account.metadata[0].name
              mountOptions = "-o allow_other --file-cache-timeout-in-seconds=120"
            }
          }
        }
      }
    }
  }
}
