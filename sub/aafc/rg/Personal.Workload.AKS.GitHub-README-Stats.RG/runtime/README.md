# Stats runtime

Owns replacement-cluster namespace, ServiceAccount, Deployment and Service.
The new managed identity is looked up by its literal name/RG; the vault, token
secret name and image digest are literals. No secret value enters Terraform.
Supply an absolute private kubeconfig path through `TF_VAR_kube_config_path`;
its fixed `Personal-AKS` context must reference the verified new cluster.
The image pins the published Stats build with curl. See the parent README for
deployment order and runtime acceptance gates.
