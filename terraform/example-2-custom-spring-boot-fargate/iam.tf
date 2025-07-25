# PLEASE NOT THIS IAM ROLE IS DIFFERENT FROM THE IAM IN IN EXAMPLE-1, EXAMPLE-GPT-1, EXAMPLE-GPT-2, AND EXAMPLE-GPT-3

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# PLEASE NOT THIS IAM ROLE IS DIFFERENT FROM THE IAM IN IN EXAMPLE-1, EXAMPLE-GPT-1, EXAMPLE-GPT-2, AND EXAMPLE-GPT-3

# Attach the AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# PLEASE NOT THIS IAM ROLE IS DIFFERENT FROM THE IAM IN IN EXAMPLE-1, EXAMPLE-GPT-1, EXAMPLE-GPT-2, AND EXAMPLE-GPT-3