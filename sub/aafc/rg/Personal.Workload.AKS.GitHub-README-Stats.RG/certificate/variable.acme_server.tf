variable "acme_server" {
  description = "Use staging for pre-cutover issuance checks; switch deliberately to production for public cutover. HTTP01 needs DNS reaching the new ingress."
  type = string
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
  validation {
    condition = contains(["https://acme-staging-v02.api.letsencrypt.org/directory", "https://acme-v02.api.letsencrypt.org/directory"], var.acme_server)
    error_message = "Choose the Let's Encrypt staging or production ACME directory."
  }
}
