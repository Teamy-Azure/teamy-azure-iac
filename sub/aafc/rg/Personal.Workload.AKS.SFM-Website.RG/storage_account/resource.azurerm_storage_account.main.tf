import {
  to = azurerm_storage_account.main
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.SFM-Website.RG/providers/Microsoft.Storage/storageAccounts/sfmwebsiteprod"
}

resource "azurerm_storage_account" "main" {
  name = "sfmwebsiteprod"
  resource_group_name = data.azurerm_resource_group.main.name
  location = "canadacentral"
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "SFM website workload"
  }
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled = true
  lifecycle {
    prevent_destroy = true
  }
}
