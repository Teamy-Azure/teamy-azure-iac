locals {
  issuer_name = var.acme_server == "https://acme-v02.api.letsencrypt.org/directory" ? "letsencrypt-prod" : "letsencrypt-staging"
}
