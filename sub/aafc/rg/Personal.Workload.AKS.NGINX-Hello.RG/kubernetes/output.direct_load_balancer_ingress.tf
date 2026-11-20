output "direct_load_balancer_ingress" { value = kubernetes_service_v1.frontend.status[0].load_balancer[0].ingress }
