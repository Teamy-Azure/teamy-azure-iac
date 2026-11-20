resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = { app = "teamy-github-readme-stats" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "teamy-github-readme-stats" } }
    template {
      metadata {
        labels = {
          app = "teamy-github-readme-stats"
          "azure.workload.identity/use" = "true"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.this.metadata[0].name
        node_selector = { "kubernetes.io/os" = "linux" }
        container {
          name = "teamy-github-readme-stats"
          image = "ghcr.io/teamdman/teamy-github-readme-stats@sha256:08af49c524ec56f7fd98fd274101ef948477688f45e8392dc797cb21492d125a"
          image_pull_policy = "IfNotPresent"
          args = ["serve", "--listen", "0.0.0.0:8080"]
          env {
            name = "KEY_VAULT_NAME"
            value = "teamygithubreadmestats"
          }
          env {
            name = "GITHUB_TOKEN_SECRET_NAME"
            value = "github-token"
          }
          env {
            name = "RUST_LOG"
            value = "info"
          }
          port { container_port = 8080 }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }
            initial_delay_seconds = 10
          }
          resources {
            requests = { cpu = "100m", memory = "64Mi" }
            limits = { cpu = "250m", memory = "256Mi" }
          }
        }
      }
    }
  }
}
