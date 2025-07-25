output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.nginx.name
}

output "ecs_service_x" {
  value = aws_ecs_service.nginx.launch_type
}

output "public_ip" {
  value = data.aws_network_interface.interface_tags.association[0].public_ip
}