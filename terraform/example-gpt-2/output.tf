output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.nginx.name
}

output "ecs_service_x" {
  value = aws_ecs_service.nginx.launch_type
}

# --------------------
# Outputs
# While this returns a value it does not work - you will still need to get the ip as described for gpt-1
# --------------------
output "load_balancer_dns" {
  value = aws_elb.nginx.dns_name
  description = "URL of the Load Balancer to access the NGINX container"
}