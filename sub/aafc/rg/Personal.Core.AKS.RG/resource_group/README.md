# Personal.Core.AKS.RG

This root creates only the destination resource group. Its name, location canadacentral, subscription and tags are literals; there are no variable inputs. The sibling aks root contains the replacement cluster specification. Do not declare or import Benthic here; Azure owns its existing managed MC group.

The Core boundary contains the cluster and shared Traefik/cert-manager add-ons.
This root is the single Core RG owner; its component siblings consume the group.
NGINX hello storage and Kubernetes objects belong to
[Personal.Workload.AKS.NGINX-Hello.RG](../../Personal.Workload.AKS.NGINX-Hello.RG/README.md)
under their own group owner, outside the AKS-managed node group. Preserve content
and credentials through the later migration.

This root and then its `aks` sibling were deployed on 18 October 2026 from exact
reviewed saved plans. Both final plans returned exit 0 with no changes.
The RG and AKS-managed node RG were
absent at preflight. AKS creates `Personal.Core.AKS.Nodes.RG`; do not create or
manage that node group in this root.

The complete literal Azure backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles` and key
`resource-groups/Personal.Core.AKS.RG/resource_group.tfstate`. The `aks` sibling
uses its distinct `aks.tfstate` key. Both use fresh states; no Benthic state is
copied or imported. Automatic Azure provider registration is disabled.

This root's full Azure state blob equals its protected Terraform-pulled backup,
with one managed resource at serial 2 and a released backend lease. The AKS state
has a distinct lineage; private custody is ignored and restricted by NTFS permissions.

Plans, backups and evidence use the protected, ignored
`ignore/deployments/Personal.Core.AKS.RG` directory. This slice created the new
Core RG and verified cluster while Benthic/workloads stayed running; add-on deployment,
DNS cutover, persistent-resource moves and reference changes are outside scope.
