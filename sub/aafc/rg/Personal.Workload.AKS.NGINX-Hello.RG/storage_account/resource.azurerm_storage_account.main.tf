import {
  to = azurerm_storage_account.main
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.NGINX-Hello.RG/providers/Microsoft.Storage/storageAccounts/nginxhellowebft3xik"
}

resource "azurerm_storage_account" "main" {
  name = "nginxhellowebft3xik"
  resource_group_name = data.azurerm_resource_group.main.name
  location = "canadacentral"
  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "NGINX hello workload"
  }
  account_tier = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  shared_access_key_enabled = true
  allow_nested_items_to_be_public = false
  lifecycle { prevent_destroy = true }
}
