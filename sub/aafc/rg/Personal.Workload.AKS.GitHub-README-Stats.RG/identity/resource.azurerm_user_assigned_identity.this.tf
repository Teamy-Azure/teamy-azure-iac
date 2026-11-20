resource "azurerm_user_assigned_identity" "this" {
  name = "personal-github-readme-stats"
  resource_group_name = "Personal.Workload.AKS.GitHub-README-Stats.RG"
  location = "canadacentral"
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "GitHub README Stats workload"
  }
  lifecycle { prevent_destroy = true }
}
