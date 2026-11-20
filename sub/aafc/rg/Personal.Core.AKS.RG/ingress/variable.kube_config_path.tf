variable "kube_config_path" {
  type = string
  validation {
    condition = length(trimspace(var.kube_config_path)) > 0
    error_message = "Supply an explicit candidate kubeconfig path."
  }
}
