output "service_name" { value = kubernetes_service_v1.frontend.metadata[0].name }
