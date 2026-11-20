resource "kubernetes_service_account_v1" "dns_contributor" {
  metadata {
    name = "dns-contributor-workload-identity"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = {
      "azure.workload.identity/use" = "true"
    }
    annotations = {
      "azure.workload.identity/client-id" = data.azurerm_user_assigned_identity.dns.client_id
      "azure.workload.identity/tenant-id" = data.azurerm_client_config.this.tenant_id
    }
  }
}
