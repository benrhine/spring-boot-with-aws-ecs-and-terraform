
# --------------------
# ECS Task Definition (NGINX)
# Exact Same in gpt-1 and gpt2
# Almost the same in gpt-3, container hostPort is set to 0 instead
# --------------------
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]
    }
  ])
}

# --------------------
# ECS Service
# Exact Same in gpt-2 and gpt-3
# --------------------
resource "aws_ecs_service" "nginx" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    elb_name       = aws_elb.nginx.name
    container_name = var.container_name
    container_port = 80
  }

  depends_on = [
    aws_autoscaling_group.ecs_asg,
    aws_elb.nginx
  ]
}

# --------------------
# Load Balancer (Classic ELB)
# --------------------
resource "aws_elb" "nginx" {
  name               = "nginx-lb"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id]
  cross_zone_load_balancing = true

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
