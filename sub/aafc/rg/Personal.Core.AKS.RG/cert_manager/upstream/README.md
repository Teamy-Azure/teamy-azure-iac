# cert-manager v1.21.2 provenance

`cert-manager.v1.21.2.yaml` is the unmodified official release asset downloaded
on 2026-10-18 from
[the v1.21.2 release](https://github.com/cert-manager/cert-manager/releases/download/v1.21.2/cert-manager.yaml).
Its SHA-256 is
`e03b668ec8675214af6b0a671699d088f2601fa3878e0dbe1b41d3feafd1879f`.

This file is an authoring/audit reference. Terraform does not execute or install
it. Its built-in Kubernetes objects have been translated into flat typed
resources. Changes from that baseline are the Terraform management labels,
originally requested controller workload-identity label and ambient flags,
immutable image digests, resource dependency/wait rules and targeted ownership
of controller-injected CA fields. The additional startup-check resources follow
the pinned upstream startup-check definitions, without Helm hooks or automatic
cleanup.

The six CRD documents were copied to `../crds/`, split at YAML separators with
their final newline normalized. Their individual hashes are recorded in
`../crds/checksums.json`. Original generated comments and the upstream
`helm.sh/resource-policy: keep` annotations remain provenance metadata. They do
not create a Helm dependency or enforce Terraform behavior; the actual
protection is Terraform's `prevent_destroy` lifecycle rule.

`image-digests.json` records Docker-Content-Digest responses from the official
`quay.io/v2/jetstack/<component>/manifests/v1.21.2` registry endpoints, verified
on 2026-10-18. The five pinned components are controller, cainjector, webhook,
acmesolver and startupapicheck. These are immutable multi-platform index pins.

The upstream Apache 2.0 [LICENSE](LICENSE) is included. Review upstream license
and release changes when refreshing this source.
