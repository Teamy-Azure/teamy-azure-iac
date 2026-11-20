resource "kubernetes_secret_v1" "storage_account" {
  metadata {
    name = "storage-account-secret"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  type = "Opaque"
  data = {
    azurestorageaccountname = data.azurerm_storage_account.main.name
    azurestorageaccountkey = data.azurerm_storage_account.main.primary_access_key
  }
}
