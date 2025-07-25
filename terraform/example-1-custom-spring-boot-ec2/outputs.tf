output "alb_dns_name" {
  value       = "${aws_lb.nginx_alb.dns_name}:8080"
  description = "The DNS name of the ALB to access your NGINX container"
}