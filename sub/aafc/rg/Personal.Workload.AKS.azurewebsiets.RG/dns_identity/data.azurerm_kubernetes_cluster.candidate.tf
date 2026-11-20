data "azurerm_kubernetes_cluster" "candidate" {
  name = "Personal-AKS"
  resource_group_name = "Personal.Core.AKS.RG"
}
