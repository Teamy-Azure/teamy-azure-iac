variable "kube_config_path" {
  type = string
  description = "Private kubeconfig path for the explicitly selected candidate cluster."
  validation {
    condition = trimspace(var.kube_config_path) != ""
    error_message = "Provide the private candidate kubeconfig path explicitly."
  }
}
