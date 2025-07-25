output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.nginx.name
}

output "alb_dns_name" {
  value       = aws_lb.nginx_alb.dns_name
  description = "The DNS name of the ALB to access your NGINX container"
}