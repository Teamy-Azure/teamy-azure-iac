terraform {
  backend "azurerm" {
    subscription_id      = "6cb7032f-2437-4f5e-91e8-676cb67e5444"
    resource_group_name  = "Teamy-Infrastructure-as-Code-RG"
    storage_account_name = "teamyiac"
    container_name       = "statefiles"
    key                  = "resource-groups/Teamy-Infrastructure-as-Code-RG/resource_group.tfstate"
  }
}
