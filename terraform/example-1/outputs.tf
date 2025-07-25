output "alb_dns_name" {
  value       = aws_lb.nginx_alb.dns_name
  description = "The DNS name of the ALB to access your NGINX container"
}