resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.hello.metadata[0].name
    labels = local.selector
  }
  spec {
    replicas = 1
    selector { match_labels = local.selector }
    template {
      metadata { labels = local.selector }
      spec {
        node_selector = { "kubernetes.io/os" = "linux" }
        container {
          name = "nginx"
          image = "nginx:stable-alpine@sha256:970364228b1e4f932abc22d321932816782cca8a20b85a77552a7cfe9acfb3b5"
          port { container_port = 80 }
          resources {
            requests = { cpu = "100m", memory = "50Mi" }
            limits = { cpu = "500m", memory = "512Mi" }
          }
          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
          }
          volume_mount {
            name = "webcontent"
            mount_path = "/usr/share/nginx/html"
            read_only = true
          }
        }
        volume {
          name = "webcontent"
          csi {
            driver = "blob.csi.azure.com"
            read_only = true
            volume_attributes = {
              containerName = "webcontent"
              storageAccount = data.azurerm_storage_account.main.name
              secretName = kubernetes_secret_v1.storage.metadata[0].name
              secretNamespace = kubernetes_namespace_v1.hello.metadata[0].name
              mountOptions = "-o allow_other --file-cache-timeout-in-seconds=120"
            }
          }
        }
      }
    }
  }
}
