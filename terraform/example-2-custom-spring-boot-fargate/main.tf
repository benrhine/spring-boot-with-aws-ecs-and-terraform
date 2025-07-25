

# --------------------
# ECS Task Definition (NGINX)
# --------------------
resource "aws_ecs_task_definition" "nginx" {
  family                   = "spring-boot-with-aws-ecs-and-terraform"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      # name  = "nginx"
      # image = "nginx:latest"
      name  = "spring-boot-with-aws-ecs-and-terraform"
      image = "rhineb/spring-boot-with-aws-ecs-and-terraform:latest"
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}"
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-task-definition"
    Environment = var.environment
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-logs"
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "nginx" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # The following 2 lines were added so it is possible to get the public ip address as an output
  enable_ecs_managed_tags = true  # It will tag the network interface with service name
  wait_for_steady_state   = true  # Terraform will wait for the service to reach a steady state


  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.alb_sg.id]
    assign_public_ip = true
  }

  tags = {
    name        = "${var.project_name}-ecs-service"
    environment = var.environment
  }
}