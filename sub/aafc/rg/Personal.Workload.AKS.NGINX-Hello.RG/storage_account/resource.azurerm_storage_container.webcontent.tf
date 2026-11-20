import {
  to = azurerm_storage_container.webcontent
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.NGINX-Hello.RG/providers/Microsoft.Storage/storageAccounts/nginxhellowebft3xik/blobServices/default/containers/webcontent"
}

resource "azurerm_storage_container" "webcontent" {
  name = "webcontent"
  storage_account_id = azurerm_storage_account.main.id
  container_access_type = "private"
  lifecycle { prevent_destroy = true }
}
