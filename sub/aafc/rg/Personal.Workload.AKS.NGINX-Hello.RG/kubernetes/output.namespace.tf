output "namespace" { value = kubernetes_namespace_v1.hello.metadata[0].name }
