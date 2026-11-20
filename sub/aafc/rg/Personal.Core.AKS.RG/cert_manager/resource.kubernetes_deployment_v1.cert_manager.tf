resource "kubernetes_deployment_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform" }
  }
  wait_for_rollout = true
  spec {
    replicas = 1
    selector {
      match_labels = { "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller" }
    }
    template {
      metadata {
        labels = { "app" = "cert-manager", "app.kubernetes.io/name" = "cert-manager", "app.kubernetes.io/instance" = "cert-manager", "app.kubernetes.io/component" = "controller", "app.kubernetes.io/version" = "v1.21.2", "app.kubernetes.io/managed-by" = "Terraform", "azure.workload.identity/use" = "true" }
        annotations = { "prometheus.io/path" = "/metrics", "prometheus.io/scrape" = "true", "prometheus.io/port" = "9402" }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.cert_manager.metadata[0].name
        automount_service_account_token = true
        enable_service_links = false
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        container {
          name = "cert-manager-controller"
          image = "quay.io/jetstack/cert-manager-controller:v1.21.2@sha256:70f532fd9cfde0b09d55687200942399d89838bc2d5d5b45152eb799a15912b8"
          image_pull_policy = "IfNotPresent"
          args = ["--v=2", "--cluster-resource-namespace=$(POD_NAMESPACE)", "--leader-election-namespace=kube-system", "--acme-http01-solver-image=quay.io/jetstack/cert-manager-acmesolver:v1.21.2@sha256:699b40d622211ab7accad8a21b04c5fbaa1841ef7a12621e8de492dbe27b2503", "--max-concurrent-challenges=60", "--cluster-issuer-ambient-credentials=true", "--issuer-ambient-credentials=true"]
          port {
            name = "http-metrics"
            container_port = 9402
            protocol = "TCP"
          }
          port {
            name = "http-healthz"
            container_port = 9403
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
              port = "http-healthz"
              path = "/livez"
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds = 10
            timeout_seconds = 15
            success_threshold = 1
            failure_threshold = 8
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
  depends_on = [kubernetes_cluster_role_binding_v1.cert_manager_cainjector, kubernetes_cluster_role_binding_v1.cert_manager_controller_approve_cert_manager_io, kubernetes_cluster_role_binding_v1.cert_manager_controller_certificates, kubernetes_cluster_role_binding_v1.cert_manager_controller_certificatesigningrequests, kubernetes_cluster_role_binding_v1.cert_manager_controller_challenges, kubernetes_cluster_role_binding_v1.cert_manager_controller_clusterissuers, kubernetes_cluster_role_binding_v1.cert_manager_controller_ingress_shim, kubernetes_cluster_role_binding_v1.cert_manager_controller_issuers, kubernetes_cluster_role_binding_v1.cert_manager_controller_orders, kubernetes_cluster_role_binding_v1.cert_manager_webhook_subjectaccessreviews, kubernetes_role_binding_v1.cert_manager_cainjector_leaderelection, kubernetes_role_binding_v1.cert_manager_leaderelection, kubernetes_role_binding_v1.cert_manager_webhook_dynamic_serving, kubernetes_manifest.cert_manager_crd, kubernetes_mutating_webhook_configuration_v1.cert_manager_webhook, kubernetes_validating_webhook_configuration_v1.cert_manager_webhook]
  timeouts {
    create = "10m"
    update = "10m"
  }
}
