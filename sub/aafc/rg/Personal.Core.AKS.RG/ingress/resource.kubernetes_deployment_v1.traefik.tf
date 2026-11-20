resource "kubernetes_deployment_v1" "traefik" {
  metadata {
    name = "traefik"
    namespace = kubernetes_namespace_v1.traefik.metadata[0].name
    labels = { "app.kubernetes.io/name" = "traefik" }
  }
  wait_for_rollout = true
  spec {
    replicas = 1
    selector { match_labels = { "app.kubernetes.io/name" = "traefik" } }
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = "1"
        max_unavailable = "0"
      }
    }
    template {
      metadata {
        labels = { "app.kubernetes.io/name" = "traefik" }
        annotations = { "checksum/config" = sha256(kubernetes_config_map_v1.traefik.data["traefik.yaml"]) }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.traefik.metadata[0].name
        automount_service_account_token = true
        termination_grace_period_seconds = 60
        node_selector = { "kubernetes.io/os" = "linux" }
        security_context {
          run_as_non_root = true
          run_as_user = 65532
          run_as_group = 65532
          fs_group = 65532
          seccomp_profile { type = "RuntimeDefault" }
        }
        container {
          name = "traefik"
          image = "docker.io/library/traefik:v3.7.14@sha256:575fa15b135078fe5e50aa847987d96dbddd7b093c172429618404df73f3fa7c"
          image_pull_policy = "IfNotPresent"
          args = ["--configFile=/etc/traefik/traefik.yaml"]
          port {
            name = "traefik"
            container_port = 8080
            protocol = "TCP"
          }
          port {
            name = "web"
            container_port = 8000
            protocol = "TCP"
          }
          port {
            name = "websecure"
            container_port = 8443
            protocol = "TCP"
          }
          readiness_probe {
            http_get {
              path = "/ping"
              port = "traefik"
            }
            failure_threshold = 1
            initial_delay_seconds = 2
            period_seconds = 10
            success_threshold = 1
            timeout_seconds = 2
          }
          liveness_probe {
            http_get {
              path = "/ping"
              port = "traefik"
            }
            failure_threshold = 3
            initial_delay_seconds = 2
            period_seconds = 10
            success_threshold = 1
            timeout_seconds = 2
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem = true
            capabilities { drop = ["ALL"] }
          }
          resources {
            requests = { cpu = "100m", memory = "128Mi" }
            limits = { memory = "256Mi" }
          }
          volume_mount {
            name = "config"
            mount_path = "/etc/traefik"
            read_only = true
          }
          volume_mount {
            name = "tmp"
            mount_path = "/tmp"
          }
          volume_mount {
            name = "data"
            mount_path = "/data"
          }
        }
        volume {
          name = "config"
          config_map { name = kubernetes_config_map_v1.traefik.metadata[0].name }
        }
        volume {
          name = "tmp"
          empty_dir {}
        }
        volume {
          name = "data"
          empty_dir {}
        }
      }
    }
  }
  depends_on = [
    kubernetes_cluster_role_binding_v1.traefik,
    kubernetes_ingress_class_v1.traefik,
    kubernetes_manifest.traefik_crd
  ]
  timeouts {
    create = "10m"
    update = "10m"
  }
}
