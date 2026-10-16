resource "azapi_resource" "blob_container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01"
  parent_id = data.azapi_resource.blob_service.id
  name      = "teamy-discord-archive"
  body = {
    properties = {
      publicAccess = "None"
    }
  }
}
