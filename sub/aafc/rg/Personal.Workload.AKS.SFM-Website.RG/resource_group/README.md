# Personal.Workload.AKS.SFM-Website.RG

This root creates only the destination resource group. Workload resources, identities, DNS, data transfer and Kubernetes manifests remain outside this root until their ownership and migration steps have been reviewed.

The adjacent [terraform.backend.tf](terraform.backend.tf) defines its complete
literal Azure backend and distinct key in `personalcorestatefile/statefiles`.
This root remains uninitialized and undeployed. Do not point it at a combined
legacy state or copy that state into multiple destinations.

Only `terraform validate` is authorized in the current task.

The subscription ID and resource tags are literals in source, matching this
group's sibling components. There are no subscription_id or tags variable inputs.

