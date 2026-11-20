resource "kubernetes_manifest" "issuer" {
  for_each = local.acme_servers
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Issuer"
    metadata = {
      name = each.key, namespace = "sfm-website"
    }
    spec = {
      acme = {
        server = each.value
        email = "TeamDman9201@gmail.com"
        privateKeySecretRef = {
          name = each.key
        }
        solvers = [{
            dns01 = {
              azureDNS = {
                subscriptionID = "6cb7032f-2437-4f5e-91e8-676cb67e5444"
                resourceGroupName = "CACN-ClusterWorkload-Benthic-sfm-website-PROD-RG"
                hostedZoneName = "superfactorymanager.ca"
                environment = "AzurePublicCloud"
                managedIdentity = {
                  clientID = data.azurerm_user_assigned_identity.dns.client_id
                }
              }
            }
        }]
      }
    }
  }
}
