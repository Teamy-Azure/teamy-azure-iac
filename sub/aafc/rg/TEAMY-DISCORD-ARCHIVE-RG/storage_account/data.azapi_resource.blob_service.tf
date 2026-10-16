data "azapi_resource" "blob_service" {
  type      = "Microsoft.Storage/storageAccounts/blobServices@2025-06-01"
  parent_id = azapi_resource.storage_account.id
  name      = "default"
}
