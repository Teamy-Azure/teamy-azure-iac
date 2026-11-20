locals {
  acme_servers = {
    letsencrypt-staging = "https://acme-staging-v02.api.letsencrypt.org/directory"
    letsencrypt-prod = "https://acme-v02.api.letsencrypt.org/directory"
  }
}
