resource "kubernetes_deployment_v1" "cert_manager_cainjector" {
  metadata {
    name = "cert-manager-cainjector"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  wait_for_rollout = true
  spec {
    replicas = 1
    selector {
      match_labels = { "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector" }
    }
    template {
      metadata {
        labels = { "app" = "cainjector", "app.kubernetes.io/name" = "cainjector", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "cainjector", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
        annotations = { "prometheus.io/path" = "/metrics", "prometheus.io/scrape" = "true", "prometheus.io/port" = "9402" }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.cert_manager_cainjector.metadata[0].name
        automount_service_account_token = true
        enable_service_links = false
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-cainjector"
          image = "quay.io/jetstack/cert-manager-cainjector:v1.21.2@sha256:c85268c64f2e0e76684bf5fe8906caff34b82523561c6affe0fae3546bd87562"
          image_pull_policy = "IfNotPresent"
          args = ["--v=2", "--leader-election-namespace=kube-system"]
          port {
            name = "http-metrics"
            container_port = 9402
            protocol = "TCP"
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
          }
        }
        node_selector = { "kubernetes.io/os" = "linux" }
      }
    }
  }
  depends_on = [kubernetes_cluster_role_binding_v1.cert_manager_cainjector, kubernetes_cluster_role_binding_v1.cert_manager_controller_approve_cert_manager_io, kubernetes_cluster_role_binding_v1.cert_manager_controller_certificates, kubernetes_cluster_role_binding_v1.cert_manager_controller_certificatesigningrequests, kubernetes_cluster_role_binding_v1.cert_manager_controller_challenges, kubernetes_cluster_role_binding_v1.cert_manager_controller_clusterissuers, kubernetes_cluster_role_binding_v1.cert_manager_controller_ingress_shim, kubernetes_cluster_role_binding_v1.cert_manager_controller_issuers, kubernetes_cluster_role_binding_v1.cert_manager_controller_orders, kubernetes_cluster_role_binding_v1.cert_manager_webhook_subjectaccessreviews, kubernetes_role_binding_v1.cert_manager_cainjector_leaderelection, kubernetes_role_binding_v1.cert_manager_leaderelection, kubernetes_role_binding_v1.cert_manager_webhook_dynamic_serving, kubernetes_manifest.cert_manager_crd]
  timeouts {
    create = "10m"
    update = "10m"
  }
}
