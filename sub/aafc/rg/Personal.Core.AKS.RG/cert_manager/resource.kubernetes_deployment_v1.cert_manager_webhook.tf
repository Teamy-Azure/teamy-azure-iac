resource "kubernetes_deployment_v1" "cert_manager_webhook" {
  metadata {
    name = "cert-manager-webhook"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  wait_for_rollout = true
  spec {
    replicas = 1
    selector {
      match_labels = { "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook" }
    }
    template {
      metadata {
        labels = { "app" = "webhook", "app.kubernetes.io/name" = "webhook", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "webhook", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
        annotations = { "prometheus.io/path" = "/metrics", "prometheus.io/scrape" = "true", "prometheus.io/port" = "9402" }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.cert_manager_webhook.metadata[0].name
        automount_service_account_token = true
        enable_service_links = false
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-webhook"
          image = "quay.io/jetstack/cert-manager-webhook:v1.21.2@sha256:a60e2dac46dbb8a7f3df95c54ce941012f54c2fe022f0ee55aaa1ab40ed957ae"
          image_pull_policy = "IfNotPresent"
          args = ["--v=2", "--secure-port=10250", "--dynamic-serving-ca-secret-namespace=$(POD_NAMESPACE)", "--dynamic-serving-ca-secret-name=cert-manager-webhook-ca", "--dynamic-serving-dns-names=cert-manager-webhook", "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE)", "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE).svc"]
          port {
            name = "https"
            container_port = 10250
            protocol = "TCP"
          }
          port {
            name = "healthcheck"
            container_port = 6080
            protocol = "TCP"
          }
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
          liveness_probe {
            http_get {
              path = "/livez"
              port = "healthcheck"
              scheme = "HTTP"
            }
            initial_delay_seconds = 60
            period_seconds = 10
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = "healthcheck"
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds = 5
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
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
