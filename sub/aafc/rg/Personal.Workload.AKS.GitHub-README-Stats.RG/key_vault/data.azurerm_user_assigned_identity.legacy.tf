data "azurerm_user_assigned_identity" "legacy" {
  name = "teamy-github-readme-stats"
  resource_group_name = "TEAMY-GitHub-README-Stats-RG"
}
