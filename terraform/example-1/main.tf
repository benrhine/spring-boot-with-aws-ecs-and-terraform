

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
  name        = "nginx-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"        # This is different!!! This is set to "instance" in example-gpt-3
  vpc_id      = aws_vpc.ecs_vpc.id

  health_check {
    path = "/"
    # example-gpt-3 has additional options set here
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

#################################################################################
# These resources are not present in example-gpt-3
#################################################################################
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "test1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}
#################################################################################
# END
#################################################################################

# https://serverfault.com/questions/977956/aws-ecs-service-not-starting-any-tasks
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

resource "aws_ecs_task_definition" "nginx" {
  family             = "nginx"
  network_mode       = "awsvpc"
  cpu                = 256
  memory              = 512

  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:latest"
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

resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.public.id, aws_subnet.public_b.id]
    security_groups = [aws_security_group.alb_sg.id]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = var.container_name
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}