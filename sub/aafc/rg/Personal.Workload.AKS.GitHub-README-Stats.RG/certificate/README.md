# Stats certificate and route

Owns the namespace HTTP01 Issuer, HTTPS Ingress, and separate host-scoped HTTP
redirect Ingress/Middleware using class `traefik`.
The runtime sibling creates the namespace and service; shared cert-manager CRDs
and Traefik's Middleware CRD/provider must already exist before planning this root.
HTTPS uses `websecure`; only the host's `web` route redirects. The more-specific
HTTP01 solver path wins by default rule-length priority. Staging is the default;
production issuer selection and external registrar cutover are deliberate Phase
2 actions. See the parent README for the DNS/HTTP01 dependency and state mapping.

Supply an absolute private path through `TF_VAR_kube_config_path`; its context is the literal
`Personal-AKS`. The ACME server input is retained because staging and production
issuance are distinct migration phases. Resource names and the ACME contact are
fixed in source.
