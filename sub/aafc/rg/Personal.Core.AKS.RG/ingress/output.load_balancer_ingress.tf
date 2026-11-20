output "load_balancer_ingress" { value = kubernetes_service_v1.traefik.status[0].load_balancer[0].ingress }
