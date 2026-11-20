terraform {
  backend "azurerm" {
    tenant_id            = "2e831e5f-9c6e-41a7-b295-50499684ba63"
    subscription_id      = "6cb7032f-2437-4f5e-91e8-676cb67e5444"
    resource_group_name  = "Personal.Core.StateFile.RG"
    storage_account_name = "personalcorestatefile"
    container_name       = "statefiles"
    key                  = "resource-groups/Personal.Workload.AKS.SFM-Website.RG/resource_group.tfstate"
    use_azuread_auth     = true
    use_cli             = true
  }
}
