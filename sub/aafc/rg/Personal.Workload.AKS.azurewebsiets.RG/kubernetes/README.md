# kubernetes

See the [group handoff and address map](../README.md) before using this independent
root. The adjacent [terraform.backend.tf](terraform.backend.tf) contains its
complete literal Azure backend and distinct state key. This root remains
uninitialized and undeployed.

Supply the machine's private kubeconfig path through `TF_VAR_kube_config_path`.
Its fixed `Personal-AKS` context must reference the verified replacement endpoint.

Future execution requires the prerequisites and staged ownership review in the group README.
