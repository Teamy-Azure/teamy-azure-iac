# cert-manager custom resource definitions

Six official cert-manager `v1.21.2` CRDs, split without schema changes from the
[pinned release manifest](https://github.com/cert-manager/cert-manager/releases/download/v1.21.2/cert-manager.yaml).
File SHA-256 values are in [checksums.json](checksums.json); source provenance
and the upstream [Apache 2.0 license](../upstream/LICENSE) are in `../upstream/`.

Terraform uses server-side apply with conflict takeover disabled. Every CRD
must report Established before the component Deployments start. No cert-manager
custom objects are declared in this installation root; those belong to the
separate workload roots after CRD installation.

The original upstream `helm.sh/resource-policy: keep` annotations are retained
as metadata. Terraform's `prevent_destroy` guard supplies actual deletion
protection because deleting a CRD cascades to its Issuer, Certificate or ACME
objects. The pinned schemas contain no conversion webhook configuration.
