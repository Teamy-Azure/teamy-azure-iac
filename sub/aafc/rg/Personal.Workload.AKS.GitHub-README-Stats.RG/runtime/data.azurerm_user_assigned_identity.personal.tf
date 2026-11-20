data "azurerm_user_assigned_identity" "personal" {
  name = "personal-github-readme-stats"
  resource_group_name = "Personal.Workload.AKS.GitHub-README-Stats.RG"
}
