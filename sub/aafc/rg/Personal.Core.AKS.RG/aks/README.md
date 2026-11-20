# Personal AKS cluster

This root completed after its resource-group sibling on 18 October 2026, using
its exact reviewed saved plan to create a separate `Personal-AKS`.
Benthic and its workloads stayed running; this slice did not deploy add-ons or
workloads, move persistent resources or change DNS.

This root manages 4 resources: the `Personal-AKS-ControlPlane` user-assigned identity, its
Network Contributor grant on Personal AKSSubnet, the cluster and a cluster-admin
RBAC grant to the existing Entra admin group. Configuration values are literals;
there are no input variables. The operator's current IPv4 is discovered through
HTTPS for the API allowlist and is not committed.

The source selects AKS `1.35.8`, one Ubuntu `Standard_D4s_v5` system node, Azure
CNI Overlay, pod range `10.242.0.0/16`, service range `10.243.0.0/16` and DNS
`10.243.0.10`. It uses the existing Personal AKSSubnet (`10.204.4.0/22`). OIDC,
workload identity and Blob/Disk/File CSI are enabled; local accounts and
run-command are disabled. AKS creates `Personal.Core.AKS.Nodes.RG` itself.
Do not create that group separately.

Preflight confirmed regional version/SKU availability, sufficient quota for a
4-vCPU node plus a 4-vCPU surge node, and operator membership in the retained
admin group. Runtime checks now confirm `Personal-AKS` 1.35.8 is Succeeded and
Running, with one Ready Standard_D4s_v5 node and all 17 system pods healthy.
CoreDNS and Blob/Disk/File CSI components and registrations passed checks.
Network/security readbacks confirmed the declared settings, including disabled
local accounts and run-command. No in-subnet probe of the state-storage account
has run; the later hello deployment verified its separate legacy Blob CSI mount.

Benthic remains Running with one Ready node, all 24 baseline controllers
preserved and all 4 apps at 1/1. Both Core RG and AKS final plans returned exit 0
with no changes.

The complete literal Azure backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles` and separate new key
`resource-groups/Personal.Core.AKS.RG/aks.tfstate`. Automatic Azure provider
registration is disabled. No Benthic state is copied, imported or reused.
Protected plans, backups and evidence use `ignore/deployments/Personal.Core.AKS.RG`.

The full Azure state blob equals the protected Terraform-pulled backup, with
4 managed resources at serial 6. Its lineage differs from the RG state and both
leases are released. Private custody is ignored and restricted by NTFS permissions.

Dedicated private Entra/kubelogin credentials were verified against the actual
endpoint and node RG; the global context remains Benthic.
Traefik and cert-manager are deployed; cert-manager's final no-change plan
and state-custody verification passed. Hello's separately authorized RG/runtime
deployment also passed readiness, read-only mounting, HTTP parity and final
no-change plans. Other workload roots require separate authorization before
deployment. See the [Core AKS overview](../README.md) for preservation and
dependency details.

Workload source is now partitioned under `Personal.Workload.AKS.*.RG`.
[NGINX hello](../../Personal.Workload.AKS.NGINX-Hello.RG/README.md) has its own
RG, storage and Kubernetes roots. Its RG/runtime are deployed; storage adoption
remains uninitialized. The source split and later hello deployment change neither
this cluster root nor its existing state key.
