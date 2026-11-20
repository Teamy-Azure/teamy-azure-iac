# Keep for recovery of these existing resources; comment out for a fresh deployment.
import {
  to = azurerm_resource_group.main
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Core.StateFile.RG"
}

resource "azurerm_resource_group" "main" {
  name     = "Personal.Core.StateFile.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal Terraform state"
  }

  lifecycle {
    prevent_destroy = true
  }
}
