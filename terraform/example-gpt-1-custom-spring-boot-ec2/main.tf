
# --------------------
# ECS Task Definition (NGINX)
# Exact Same in gpt-1 and gpt2
# Almost the same in gpt-3, container hostPort is set to 0 instead
# --------------------
resource "aws_ecs_task_definition" "nginx" {
  family                   = "spring-boot-with-aws-ecs-and-terraform"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      # name      = "nginx"
      # image     = "nginx:latest"
      name  = "spring-boot-with-aws-ecs-and-terraform"
      image = "rhineb/spring-boot-with-aws-ecs-and-terraform:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "nginx" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  launch_type     = "EC2"
  desired_count   = 1

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}