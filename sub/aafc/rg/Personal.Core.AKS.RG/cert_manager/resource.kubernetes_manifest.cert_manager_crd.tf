resource "kubernetes_manifest" "cert_manager_crd" {
  for_each = fileset("${path.module}/crds", "*.yaml")
  manifest = yamldecode(file("${path.module}/crds/${each.value}"))
  field_manager {
    name = "terraform"
    force_conflicts = false
  }
  wait {
    condition {
      type = "Established"
      status = "True"
    }
  }
  # Deleting these CRDs would delete existing issuers, certificates and requests.
  lifecycle { prevent_destroy = true }
}
