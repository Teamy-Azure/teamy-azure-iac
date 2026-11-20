import {
  to = azurerm_key_vault.this
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.GitHub-README-Stats.RG/providers/Microsoft.KeyVault/vaults/teamygithubreadmestats"
}

resource "azurerm_key_vault" "this" {
  name = "teamygithubreadmestats"
  location = "canadacentral"
  resource_group_name = "Personal.Workload.AKS.GitHub-README-Stats.RG"
  tenant_id = "2e831e5f-9c6e-41a7-b295-50499684ba63"
  sku_name = "standard"
  purge_protection_enabled = true
  soft_delete_retention_days = 90
  rbac_authorization_enabled = true
  public_network_access_enabled = true
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "GitHub README Stats workload"
  }
  lifecycle { prevent_destroy = true }
}
