resource "kubernetes_manifest" "traefik_crd" {
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
  # Removing a CRD deletes its custom resources across every workload namespace.
  lifecycle { prevent_destroy = true }
}
