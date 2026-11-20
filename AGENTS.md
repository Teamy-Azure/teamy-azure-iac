# Deployment source conventions

Minimize indirection. These roots describe one concrete deployment, not a reusable
Terraform module. Prefer literals for values expected to have one value: resource
names, storage account names, locations, subscription and tenant IDs, tags, SKUs,
versions, image digests and fixed Kubernetes contexts. Change those values in
source rather than adding variables, locals or tfvars merely for author convenience.

Use direct resource references or fixed-name data lookups for generated IDs and
other actual resource dependencies. Do not require an operator to copy an output
into another root's variable when a direct Azure lookup expresses the dependency.
Keep resource-group ownership in its resource_group sibling; component roots
must not create a second copy of the group.

Name primary Azure resource-group and storage-account resources/data lookups
main rather than this. A resource-group root exposes one resource_group output
containing the complete azurerm_resource_group.main object. A storage-account
root exposes one storage_account output containing azurerm_storage_account.main;
mark it sensitive because the resource object includes keys/connection strings.
Avoid separate ID/name outputs for the same object.

Keep an input only when it has a real operational purpose, such as a private
machine's credential path, a changing traffic-cutover target or an actual staged
workflow choice. Explain each retained input. Do not hard-code secrets or private
machine/network values to remove a variable.
Do not add terraform.tfvars.example files, including comment-only placeholders.
Document genuine operational inputs in the owning root's README and supply them
through TF_VAR_ environment variables. Retain deliberate staging/production
workflow choices; example-file cleanup does not authorize changing ACME policy.

Deploy Kubernetes components as flat, direct hashicorp/kubernetes resources in
their sibling roots. Do not introduce Helm providers/releases, chart rendering,
Helm install helpers or wrapper modules. Vendor pinned official CRD schemas when
needed and record provenance; deployment must not download/render charts.

Keep each Personal Azure backend's tenant, account, container, unique state key
and Entra/CLI authentication literals in terraform.backend.tf. Keep the known
subscription ID as a comment so OpenTofu passes only the tenant to Azure CLI.
Set both tenant and subscription IDs in Azure provider blocks where supported.
Do not add redundant backend example/config files. The two StateFile bootstrap
roots retain their existing independent local backends and protected states.

Follow the migration plan's current execution authorization. Phase 1 permits
only Terraform validate. The user subsequently authorized Phase 2 bootstrap of
Personal.Core.StateFile.RG/resource_group followed by its storage_account sibling,
including necessary initialization, saved-plan review, application and access
verification. This does not authorize other deployments or state/backend moves.
The subsequent bootstrap recovery request adds declarative imports for the four
already deployed resources while retaining both local backends. Keep those
imports active for state recovery; comment them out only for a genuinely fresh
deployment. Pin the deployed writer principal so another caller does not replace
its access grant; the import records the deployed assignment ID. Reflow removes
the role resource's computed name, so refresh its import ID after a fresh deploy.
Source reflow and validate are permitted;
executing imports, plans, applies or backend relocation is not part of this edit.
The subsequent Personal networking deployment is explicitly authorized:
Personal.Core.Networking.RG/resource_group followed by its vnet sibling, including
the three declared subnets. Use distinct new Azure-backed state keys in
personalcorestatefile/statefiles, Entra authentication, reviewed saved plans and
post-apply verification. This authorization does not extend to AKS, peering,
legacy state migration or reference networking/agents.
The networking storage_account_network_access sibling is also authorized to add
Personal AKSSubnet access to personalcorestatefile, preserving all other ACLs.
Bootstrap delegates only virtual_network_subnet_ids through selective ignore;
it retains default-deny/operator-IP ownership. Serialize these two roots' ACL
updates, review the complete preserved ACL privately and use a separate new
remote key for the access root. This does not authorize wider subnet access,
RBAC changes, AKS deployment or reference-state/network changes.
The subsequent user request authorizes Personal.Core.AKS.RG/resource_group and
then its aks sibling: fresh separate remote state keys, reviewed plans, apply
and readiness/state verification. Keep Benthic and its workloads running. Do not
cut over DNS, move retained resources or deploy add-ons/workloads in this slice.
The concurrent Traefik follow-up replaces the ingress Helm release with direct
Kubernetes Terraform resources; reflow/validate that source only. It does not
authorize ingress installation or changes to Benthic.
The subsequent ingress deployment request authorizes only the ingress sibling
on Personal-AKS, with its own fresh Entra-authenticated remote state key in
personalcorestatefile/statefiles, reviewed saved-plan apply, public-listener/
controller readiness and state verification. Keep Benthic and its workloads
running. Do not install cert-manager or workloads, change DNS, move retained
resources or migrate legacy state as part of this slice.
The subsequent all-Helm conversion request is source-only: replace the remaining
undeployed cert-manager Helm root and remove every active Personal Helm
dependency. Reflow/validate and update source/ownership documentation. Preserve
historical Benthic Helm addresses for migration provenance, its running release,
and the deployed direct Traefik resources. This does not authorize cert-manager
installation, state migration or other cloud changes.
The subsequent backend cleanup request authorizes source configuration cleanup
across Personal roots, removal of unused backend examples and documentation
updates, with reflow/validate only. Preserve deployed backend pointers, cached
initialization metadata, bootstrap local states and upstream reference files.
Do not initialize/reconfigure backends, migrate state, plan or deploy anything.
The subsequent cert-manager deployment request authorizes the cert_manager
sibling on Personal-AKS using its distinct new remote state, reviewed saved-plan
apply and controller/admission/identity/state verification. A disposable local
self-signed readiness probe and its guarded cleanup are within verification;
do not issue public certificates, deploy application Issuers/workloads, change
DNS or migrate legacy state. Leave Benthic and its workloads running, and
preserve deployed Traefik and the default Kubernetes context.
The subsequent workload-layout request is source-only. NGINX hello belongs in
Personal.Workload.AKS.NGINX-Hello.RG with resource_group, storage_account and
kubernetes siblings. Existing Personal workload groups gain the
Personal.Workload.AKS. prefix. Update undeployed backend keys, future move/import
IDs and references together. Preserve all deployed Core/network/bootstrap
resources, backend pointers/caches and local state. Keep existing application
names, Kubernetes namespaces, storage/DNS names and legacy overlap lookups.
Do not initialize/reconfigure backends, migrate state, plan, deploy or execute
Azure resource-group moves as part of this source refactor.
The subsequent user request authorizes NGINX hello deployment after the source
refactor passes: deploy Personal.Workload.AKS.NGINX-Hello.RG/resource_group and
then kubernetes using distinct fresh Azure states, reviewed saved plans and
readiness/content/state verification. Use the retained legacy storage account
read-only during overlap. Preserve Benthic, its workloads, DNS and the deployed
shared platform. Do not move/adopt the storage account or initialize/apply its
storage_account sibling in this slice; physical moves remain separately gated.
The subsequent input-example cleanup is source/documentation-only: remove the
remaining terraform.tfvars.example files and review Stats as the next candidate.
Retain actual operational inputs and its staging ACME default. This does not
authorize Stats initialization/deployment, vault moves or DNS/certificate cutover.
The subsequent recovery request authorizes restoring Personal-AKS, verifying its
deployed workloads, and deploying Stats privately in resource_group, identity,
runtime order. Use the retained vault and fresh Personal state keys. Reserve
Benthic recovery, public routing, DNS, TLS and vault adoption for their own slices.
The subsequent Stats request authorizes publishing the image with curl, updating
only the existing Personal Stats runtime's pinned digest, and running a single
read-only GitHub GraphQL diagnostic from the Stats pod through its existing
workload identity and vault credential. Return only sanitized status information.
Run cloud_terrastodon.exe terraform reflow --recursive on changed group trees
and validate affected roots. Keep the two bootstrap local states independent.
If a disk-space error occurs, stop and wait for the user to resolve it.
