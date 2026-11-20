# Personal AKS NGINX hello workload

This workload has three independent sibling Terraform roots. Its RG and
Kubernetes runtime deployed on 18 October 2026; storage adoption remains
uninitialized and undeployed.

| Root | Ownership |
| --- | --- |
| `resource_group/` | Deployed `Personal.Workload.AKS.NGINX-Hello.RG`; exposes the complete `azurerm_resource_group.main` object. |
| `storage_account/` | Future adoption of `nginxhellowebft3xik` and its private `webcontent` container after their separately approved Azure resource-group move. Imports and `prevent_destroy` protect the retained account/container. |
| `kubernetes/` | Deployed `nginx-hello` namespace, storage Secret, frontend Deployment, direct LoadBalancer Service and hostless Traefik Ingress on Personal-AKS. |

The cluster, shared Traefik ingress and cert-manager stay in
`Personal.Core.AKS.RG`. These folders previously lived there as
`nginx_hello_storage/` and `nginx_hello/`; the preceding source-only refactor moved
their source ownership here without moving live resources, state blobs or backend
initialization. The later deployment created fresh objects and new states.

All three roots use literal Entra/Azure CLI backend settings in
`terraform.backend.tf`, with distinct fresh keys in
`personalcorestatefile/statefiles`:

- `resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/resource_group.tfstate`
- `resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/storage_account.tfstate`
- `resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/kubernetes.tfstate`

The Kubernetes namespace, workload names, pinned nginx image, account name,
container and existing Benthic routing remain unchanged. The Kubernetes root's
private kubeconfig path is an operational input; its context is fixed to
`Personal-AKS`. The storage-group lookup intentionally remains
`CACN-ClusterWorkload-Benthic-nginx-PROD-RG` during overlap. Its destination-group
lookup already names the new workload RG. Its group was deployed before the
Kubernetes sibling; storage adoption has not been initialized or evaluated live.

## Deployment acceptance on 18 October 2026

Exact reviewed saved plans added one RG and then 5 Kubernetes objects, with no
changes or deletions. Both final plans returned exit 0 with no changes. The
frontend is 1/1 Ready with zero restarts; its runtime image matches the pinned
index or Linux amd64 manifest. The actual read-only Blob CSI mount serves the
retained account's `webcontent` container. No Secret values were read during
runtime acceptance.

The new direct LoadBalancer and hostless Traefik `/` route both return HTTP 200
with the same 84-byte body/hash as Benthic's original hello. The Ingress publishes the
shared Traefik address. HTTPS returned 404 with certificate validation
skipped; trusted workload TLS is not established. Traefik Deployment/Service UIDs,
generations and address are preserved, and all 3 cert-manager Deployments remain
Ready with unchanged UIDs/generations.

Benthic remains Running with one Ready node, all 24 controllers and 4 apps ready.
Its old hello still returns the original HTTP content; the global context remains
Benthic. The retained account's ID, RG, endpoint, ACL, key-creation metadata,
SKU and tags are unchanged, as are container ID, ETag and access settings.
No account move/adoption, blob write or DNS update occurred.

The RG state has one managed instance at serial 2; Kubernetes has 5 at serial 3.
Each full pulled state equals its direct Entra-authenticated Azure blob download,
with the exact reviewed addresses, stable ETag and released lease. Both lineages
differ from each other and all 4 Core states. Plans, state backups, credentials
and verification evidence are ignored and restricted to the operator, SYSTEM
and local Administrators under
`ignore/deployments/Personal.Workload.AKS.NGINX-Hello.RG`.
Private evidence includes `verification/runtime-acceptance.json`,
`verification/retained-storage-acceptance.json` and
`verification/state-custody-summary.json`. Run
`terraform output direct_load_balancer_ingress` from the Kubernetes root for its
current direct address. The [ingress root README](../Personal.Core.AKS.RG/ingress/README.md)
provides the shared address command; generated public addresses are not committed here.

## Persistent data and ownership handoff

1. Preserve the complete live `webcontent` inventory, checksums and tested
   recovery copy, including content beyond `index.html`. The legacy source
   fixture is not a live-content backup.
2. Keep the verified candidate runtime reading the account in its existing
   resource group. Both clusters now read the same account during overlap; retain
   their network access, storage credentials and read-only Blob CSI mounting.
   Keep Benthic serving traffic.
3. Under a separately approved writer freeze, move the retained account into
   `Personal.Workload.AKS.NGINX-Hello.RG`. Preserve its endpoint, key and blob
   bytes. Adopt the account/container through the destination ARM-ID imports in
   `storage_account/`. An absent destination fails import rather than creating
   an empty replacement. Review for zero replacements and content writes.
4. Reconcile the legacy account/container owner once, then update the runtime's
   literal storage-group lookup. Deliberately release the old blob address
   without deleting its bytes; content publication becomes an external operation.
   Retain Benthic access, state and routing rollback through acceptance.

| Legacy address in `teamdman.tfstate` | Destination/disposition |
| --- | --- |
| `module.nginx_hello.azurerm_storage_account.web` | `storage_account/`: `azurerm_storage_account.main`, after the Azure RG move. |
| `module.nginx_hello.azurerm_storage_container.web` | `storage_account/`: `azurerm_storage_container.webcontent`, after the Azure RG move. |
| `module.nginx_hello.azurerm_storage_blob.index` | Retain existing bytes and release old Terraform ownership deliberately; no upload resource in these roots. |
| Old hello Kubernetes objects | Fresh objects in `kubernetes/` on Personal-AKS; preserve old objects/state during overlap. |
| Old hello RG and random suffix | Retain through all data/ownership handoffs; no random renaming or automatic teardown. |

Do not copy the combined `teamdman.tfstate` into any sibling state. Storage keys
are retrieved only when the runtime is evaluated against Azure and become
restricted Terraform state/Kubernetes Secret data. The runtime exposes no storage
key output. The storage owner follows the whole-object output convention: its
`storage_account` output is sensitive and includes account keys, so protect its
state and avoid displaying that output.

## Validation and execution boundary

The separately authorized RG/runtime deployment and acceptance are complete.
The storage-account sibling remains uninitialized and owns no live resources.
Source reflow and Terraform validation do not authorize its adoption, retained
resource moves or traffic cutover. These require separate reviewed plans and
approval. See the
[migration plan](../../../../docs/personal-migration.md) for preservation and
workload restoration gates.
