# --------------------
# Load Balancer (ALB)
# --------------------
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_b.id]

  tags = {
    name = "nginx-alb"
  }
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"        # This is different!!! This is set to "ip" in example 1
  vpc_id   = aws_vpc.ecs_vpc.id

  health_check {
    path                = "/"
    # All options below this comment are not set in example 1
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# --------------------
# ECS Task Definition (Dynamic Port Mapping)
# --------------------
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 0    # dynamic port mapping
        protocol      = "tcp"
      }]
    }
  ])
}

# --------------------
# ECS Service
# --------------------
resource "aws_ecs_service" "nginx" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = var.container_name
    container_port   = 80
  }

  depends_on = [
    aws_autoscaling_group.ecs_asg,
    aws_lb_listener.nginx_listener
  ]
}