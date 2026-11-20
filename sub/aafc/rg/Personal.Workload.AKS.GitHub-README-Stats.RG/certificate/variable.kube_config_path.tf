variable "kube_config_path" {
  description = "Explicit kubeconfig path for the replacement Personal cluster. Never commit credentials."
  type = string
  validation {
    condition = length(trimspace(var.kube_config_path)) > 0
    error_message = "Supply a nonempty kubeconfig path for the replacement cluster."
  }
}
