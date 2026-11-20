data "azurerm_kubernetes_cluster" "personal" {
  name = "Personal-AKS"
  resource_group_name = "Personal.Core.AKS.RG"
}
