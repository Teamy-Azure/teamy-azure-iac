resource "kubernetes_job_v1" "startup_api_check" {
  metadata {
    name = "cert-manager-startupapicheck"
    namespace = kubernetes_namespace_v1.main.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = "cert-manager-startupapicheck"
      "app.kubernetes.io/version" = "v1.21.2"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }
  wait_for_completion = true
  spec {
    backoff_limit = 4
    active_deadline_seconds = 300
    template {
      metadata { labels = { "app.kubernetes.io/name" = "cert-manager-startupapicheck" } }
      spec {
        service_account_name = kubernetes_service_account_v1.startup_api_check.metadata[0].name
        automount_service_account_token = true
        enable_service_links = false
        restart_policy = "OnFailure"
        node_selector = { "kubernetes.io/os" = "linux" }
        security_context {
          run_as_non_root = true
          seccomp_profile { type = "RuntimeDefault" }
        }
        container {
          name = "cert-manager-startupapicheck"
          image = "quay.io/jetstack/cert-manager-startupapicheck:v1.21.2@sha256:46e75b6866359ffb5d82624f41e3ed1c70b2994982702ced547ce5edb418a8f5"
          image_pull_policy = "IfNotPresent"
          args = ["check", "api", "--wait=2m"]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref { field_path = "metadata.namespace" }
            }
          }
          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem = true
            capabilities { drop = ["ALL"] }
          }
          resources {
            requests = { cpu = "10m", memory = "64Mi" }
            limits = { memory = "128Mi" }
          }
        }
      }
    }
  }
  # Keep this completed Job tracked. A relevant component change reruns admission.
  lifecycle {
    replace_triggered_by = [
      kubernetes_deployment_v1.cert_manager,
      kubernetes_deployment_v1.cert_manager_cainjector,
      kubernetes_deployment_v1.cert_manager_webhook,
      kubernetes_mutating_webhook_configuration_v1.cert_manager_webhook,
      kubernetes_validating_webhook_configuration_v1.cert_manager_webhook,
      kubernetes_manifest.cert_manager_crd
    ]
  }
  depends_on = [
    kubernetes_role_binding_v1.startup_api_check,
    kubernetes_deployment_v1.cert_manager,
    kubernetes_mutating_webhook_configuration_v1.cert_manager_webhook,
    kubernetes_validating_webhook_configuration_v1.cert_manager_webhook
  ]
  timeouts { create = "10m" }
}
