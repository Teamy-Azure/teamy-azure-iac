resource "azapi_resource" "storage_account" {
  type      = "Microsoft.Storage/storageAccounts@2025-06-01"
  parent_id = data.azapi_resource.resource_group.id
  name      = "teamydiscordarchive"
  location  = "canadacentral"
  body = {
    kind = "StorageV2"
    sku = {
      name = "Standard_LRS"
    }
    properties = {
      accessTier = "Hot"
      minimumTlsVersion = "TLS1_2" # 2026-04-01 "Feature MinimumTlsVersion 1.3 is not supported."
    }
  }
}
