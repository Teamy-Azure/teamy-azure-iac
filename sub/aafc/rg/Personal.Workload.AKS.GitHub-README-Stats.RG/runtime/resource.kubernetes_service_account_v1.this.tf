resource "kubernetes_service_account_v1" "this" {
  metadata {
    name = "teamy-github-readme-stats"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = { "app.kubernetes.io/name" = "teamy-github-readme-stats" }
    annotations = {
      "azure.workload.identity/client-id" = data.azurerm_user_assigned_identity.personal.client_id
      "azure.workload.identity/tenant-id" = data.azurerm_user_assigned_identity.personal.tenant_id
    }
  }
}
