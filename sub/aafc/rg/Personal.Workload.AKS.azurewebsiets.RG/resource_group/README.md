# Personal.Workload.AKS.azurewebsiets.RG

This root creates only the destination resource group. The spelling azurewebsiets is retained exactly from the requested destination. Workload resources, identities, DNS, data transfer and Kubernetes manifests remain outside this root until their ownership and migration steps have been reviewed.

The migration plan explicitly moves the existing `azurewebsiets.net` zone into this group, preserving its nameservers and current traffic targets. Its zone/record IDs, DNS role grants and certificate solver group settings need coordinated reconciliation. Moving the zone and switching ingress traffic are separate later operations; this root does not create a replacement zone.

The adjacent [terraform.backend.tf](terraform.backend.tf) defines its complete
literal Azure backend and distinct key in `personalcorestatefile/statefiles`.
This root remains uninitialized and undeployed. Do not point it at a combined
legacy state or copy that state into multiple destinations.

Only `terraform validate` is authorized in the current task.

The subscription ID and resource tags are literals in source, matching this
group's sibling components. There are no subscription_id or tags variable inputs.

