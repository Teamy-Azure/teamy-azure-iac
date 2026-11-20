import {
  to = azurerm_dns_zone.this
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.azurewebsiets.RG/providers/Microsoft.Network/dnszones/azurewebsiets.net"
}

resource "azurerm_dns_zone" "this" {
  name = "azurewebsiets.net"
  resource_group_name = data.azurerm_resource_group.main.name
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "Azure websites workload"
  }
  lifecycle {
    prevent_destroy = true
  }
}
