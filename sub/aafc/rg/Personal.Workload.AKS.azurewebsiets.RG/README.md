# Azurewebsiets sibling roots

Every directory is an independent root. `resource_group/` is the sole RG owner;
payload roots look it up. Each root's `terraform.backend.tf` has complete literal
Azure settings and its own key in `personalcorestatefile/statefiles`. These roots
remain uninitialized and undeployed. Source reflow and validate are the only
current execution authorization.

| Root | Purpose |
| --- | --- |
| `storage_account/` | Adopt the existing moved account and private webcontent container; never upload/overwrite blobs. |
| `dns/` | Adopt the original moved azurewebsiets.net zone and apex/wildcard records; preserve the old traffic target through explicit input. |
| `dns_identity/` | New candidate identity, Personal-AKS OIDC lookup and zone-scoped DNS grant. |
| `kubernetes/` | Candidate namespace, storage Secret, ConfigMap, frontend, Service and Traefik-class Ingress, plus preserved DNS service account. |
| `certificates/` | DNS01 staging/production Issuers, after namespace, cert-manager CRDs, OIDC trust and RBAC exist. |

## Staged preservation and adoption

1. Inventory/checksum every live webcontent blob and retain a tested recovery
   copy. Preserve secrets/certificate account material privately. The legacy index.html declaration does not prove that all live bytes are captured; retain the complete existing container.
2. Freeze applicable legacy Terraform writers and retain state/ID mappings.
   Under separate execution authorization move the existing storage account from
   `CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG` to `Personal.Workload.AKS.azurewebsiets.RG`.
   Keep its name, data and key; review move dependencies and network reachability.
3. Move the original DNS zone to the destination group preserving assigned
   nameservers, all record sets, TTLs and current ingress values. Reconcile old
   and new DNS-writer grants at the destination zone ID and active Issuer solver
   resource-group settings. Retain the old DNS identity until its writers drain;
   user-assigned identities are replaced separately.
4. Literal post-move IDs feed declarative `import` blocks. Missing resources
   fail import instead of silently creating an empty replacement zone/account.
   Review the future adoption plan for zero replacement, content writes or DNS
   changes. Reconcile old ownership exactly once under the freeze and keep all
   backups. Do not copy the entire combined legacy state into a sibling key.
5. Create the replacement DNS identity using the Personal-AKS data lookup and
   the literal zone group for that stage. The old identity retains old-cluster
   trust during overlap. Verify the cert-manager ServiceAccount subject and a
   controlled staging DNS01 challenge before production.
6. Kubernetes providers select the literal Personal-AKS context. Verify that
   the supplied private kubeconfig resolves it to the replacement resource ID.
   Blob CSI/shared-key support and storage access must work. Verify retained
   content and the pinned official nginx image. Storage keys enter restricted Terraform state as a Kubernetes Secret. The runtime has no key output; the storage sibling exposes its complete account object as a sensitive output.
7. Apply the certificate root only after namespace/CRDs exist. Validate cannot
   prove live CRD discovery, identity access, public content or certificate
   issuance. Change `traffic_ipv4_address` only at separately authorized cutover;
   keep old-cluster rollback through acceptance.

Traefik's Kubernetes Ingress provider replaces the retired shared nginx
controller, with ingress class `traefik`. The nginx application container and
its configuration are independent of that controller. The official nginx stable-alpine image is pinned by immutable digest.

ExternalDNS was commented out in source and absent from the live audit. No controller or unused external-dns trust is introduced. The preserved DNS service account is not selected by the nginx frontend, matching its old role.

## Address map

The legacy combined root uses `azurewebsiets.tfstate`; new component states are separate.

| Legacy address | Destination |
| --- | --- |
| `module.azurewebsiets.azurerm_storage_account.web` | `storage_account: azurerm_storage_account.main` |
| `module.azurewebsiets.azurerm_storage_container.web` | `storage_account: azurerm_storage_container.webcontent` |
| `module.azurewebsiets.azurerm_dns_zone.main` | `dns: azurerm_dns_zone.this` |
| `module.azurewebsiets.azurerm_dns_a_record.apex` | `dns: azurerm_dns_a_record.frontend["apex"]` |
| `module.azurewebsiets.azurerm_dns_a_record.wildcard` | `dns: azurerm_dns_a_record.frontend["wildcard"]` |
| Old identity, FIC and zone grant | Retain until drained; new identity/trusts are separate resources. |
| Old Kubernetes resources | Recreate on candidate; leave old cluster/state intact through cutover. |
| Old resource group | Retain until empty; destination has only the existing RG-root owner. |
| Legacy index blob/local file | Preserve bytes; reconcile old upload ownership without deleting the blob. No new blob resource. |

New Kubernetes addresses are `kubernetes_namespace_v1.this`,
`kubernetes_deployment_v1.frontend`, `kubernetes_service_v1.frontend`,
`kubernetes_ingress_v1.frontend`, `kubernetes_config_map_v1.nginx_conf` and
`kubernetes_secret_v1.storage_account`. New Issuer addresses are
`kubernetes_manifest.issuer["letsencrypt-staging"]` and
`kubernetes_manifest.issuer["letsencrypt-prod"]`. These are candidate resources,
not a provider repoint of old Kubernetes state.

Before execution compare live storage settings, existing content-writer grants,
all DNS records, identity access, object labels/annotations and rendered content.
The two A records are not an inventory of the entire zone. Terraform source
validation does not replace these preservation and acceptance checks.

The Kubernetes root additionally requires Traefik's Middleware CRD and enabled
Kubernetes CRD provider. It creates a namespace-local HTTPS redirect Middleware
and a separate HTTP Ingress. The HTTPS route binds websecure with TLS enabled;
only the matching workload hosts redirect. Core hello HTTP remains reachable,
and no global redirect or priority override interferes with HTTP01 solvers.

## Remaining exact legacy addresses

Candidate Kubernetes objects in this map are fresh objects on a different cluster.
Keep old-cluster state intact through acceptance; do not transplant it.

| Legacy address | Candidate or retained disposition |
| --- | --- |
| `module.azurewebsiets.azurerm_resource_group.web` | Retain old RG until empty; destination resource_group/azurerm_resource_group.main is new. |
| `module.azurewebsiets.azurerm_user_assigned_identity.dns_contributor` | Retain old; dns_identity/azurerm_user_assigned_identity.cert_manager_dns is new. |
| `module.azurewebsiets.azurerm_federated_identity_credential.cert_manager` | Retain old; new dns_identity/azurerm_federated_identity_credential.cert_manager_dns is separate. |
| `module.azurewebsiets.azurerm_federated_identity_credential.external_dns` | Inactive legacy trust; no candidate controller/trust. Retain until explicit cleanup. |
| `module.azurewebsiets.azurerm_role_assignment.dns_contributor` | Reconcile old writer at moved zone as dns/azurerm_role_assignment.retained_dns_writer; new identity has a separate grant. |
| `module.azurewebsiets.kubernetes_namespace.main` | kubernetes/kubernetes_namespace_v1.this |
| `module.azurewebsiets.kubernetes_deployment.nginx` | kubernetes/kubernetes_deployment_v1.frontend |
| `module.azurewebsiets.kubernetes_config_map.nginx_conf` | kubernetes/kubernetes_config_map_v1.nginx_conf |
| `module.azurewebsiets.kubernetes_secret.storage_key` | kubernetes/kubernetes_secret_v1.storage_account |
| `module.azurewebsiets.kubernetes_service.frontend` | kubernetes/kubernetes_service_v1.frontend |
| `module.azurewebsiets.kubernetes_service_account.dns_contributor` | kubernetes/kubernetes_service_account_v1.dns_contributor |
| `module.azurewebsiets.kubernetes_ingress_v1.frontend` | kubernetes/kubernetes_ingress_v1.frontend plus new HTTP redirect resources. |
| `module.azurewebsiets.kubernetes_manifest.letsencrypt_staging_issuer` | certificates/kubernetes_manifest.issuer["letsencrypt-staging"] |
| `module.azurewebsiets.kubernetes_manifest.letsencrypt_prod_issuer` | certificates/kubernetes_manifest.issuer["letsencrypt-prod"] |
| `random_string.suffix` | Retain resolved old account name; no new suffix. |
| `module.azurewebsiets.data.local_file.index` | No candidate fixture upload; retain live bytes. |

Subscription IDs, tags, locations, contacts, known names and import paths are
literals in source. Metadata lookups derive replacement OIDC and client IDs.
Only the private kubeconfig path and intentional DNS traffic cutover target
remain deployment inputs. There are no subscription, tag or image overrides.


## Literal deployment values and staged source edits

Read-only Azure metadata on 2026-10-16 verified retained storage account
`azurewebsietsweba3bky` in Canada Central. The adoption account/container IDs and original
zone IDs are literal destination paths; import still fails if the moved resources
do not exist. These roots cannot silently create empty replacements.

The candidate initially reads storage and DNS in `CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG`.
During the separately authorized storage move, edit the literal group in
`kubernetes/data.azurerm_storage_account.main.tf` to `Personal.Workload.AKS.azurewebsiets.RG`.
During the independent zone move, edit the literal DNS group in
`dns_identity/data.azurerm_dns_zone.this.tf` and
`certificates/resource.kubernetes_manifest.issuer.tf` to `Personal.Workload.AKS.azurewebsiets.RG`.
Also reconcile the active old cluster's solver and role scopes under its own
reviewed owner. Those source edits and moves are later Phase 2 work.

The new identity reads `Personal-AKS` in `Personal.Core.AKS.RG` and the
certificate/runtime roots look up the named new identity in this destination RG.
No OIDC URL or client ID must be copied between tfvars files. The retained DNS
writer grant reads the original identity in its old group, so retain that
identity until old writers drain. Remove that lookup/grant only in the separately
reviewed retirement edit. Context names alone cannot verify the API server;
confirm the actual candidate Azure resource ID before execution.


The frontend uses the official nginx stable-alpine immutable index digest
`sha256:970364228b1e4f932abc22d321932816782cca8a20b85a77552a7cfe9acfb3b5`,
resolved through read-only Docker Registry metadata on 2026-10-16 with Linux amd64
present. See the [official nginx image](https://hub.docker.com/_/nginx). No image
was pulled or deployed; mounting, serving behavior and content checks remain
Phase 2 acceptance work.



The primary managed RG and storage resources use the name `main`. The RG root
exports one `resource_group` object. The storage root exports one sensitive
`storage_account` object; Azure storage account objects include key fields, so
treat that output as secret data. No credentials were read or printed by this
source change. Payload data-source names remain `this`. These roots have not
been applied, so this naming change needs no state migration.
