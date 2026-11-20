# Read only ARM metadata, not the account's keys or connection strings.
data "azapi_resource" "main" {
  type        = "Microsoft.Storage/storageAccounts@2025-08-01"
  name        = "personalcorestatefile"
  parent_id   = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Core.StateFile.RG"
  response_export_values = ["properties.networkAcls"]
}
