provider "kubernetes" {
  config_path = pathexpand(var.kube_config_path)
  config_context = "Personal-AKS"
}
