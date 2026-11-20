# Traefik custom resource definitions

These ten YAML files are the official Traefik `v3.7.14` CRD bundle, split at YAML
document separators into one file per `metadata.name`. The document content is
unchanged apart from normalizing the final newline. `checksums.json` records the
SHA-256 of each vendored file. The root uses server-side apply through
`kubernetes_manifest`, with conflict takeover disabled.

Pinned upstream bundle:
[kubernetes-crd-definition-v1.yml](https://github.com/traefik/traefik/blob/v3.7.14/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml).
The upstream MIT license is included as [LICENSE.md](LICENSE.md).

The complete CRD provider set is installed because the controller watches all
ten kinds even though the current workloads only create Middleware objects.
Gateway API CRDs are not included and that provider is not enabled.

For an upgrade, review the pinned Traefik release and its full CRD bundle,
replace these definitions together, refresh checksums and review the resulting
Terraform plan before deployment. Do not edit generated schema fields to make
individual plans pass. Deleting a CRD also deletes its custom objects; Terraform
therefore guards CRD destruction explicitly.
