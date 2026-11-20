import {
  to = azurerm_dns_zone.this
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.SFM-Website.RG/providers/Microsoft.Network/dnszones/superfactorymanager.ca"
}

resource "azurerm_dns_zone" "this" {
  name = "superfactorymanager.ca"
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "SFM website workload"
  }
  lifecycle {
    prevent_destroy = true
  }
}
