
# Security group for ECS EC2 instances
resource "aws_security_group" "alb_sg" {
  name   = "${var.project_name}-security-group"
  description = "Allow inbound traffic for ECS tasks"
  vpc_id = aws_vpc.ecs_vpc.id

  ingress {
    description = "Allow HTTP inbound"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name        = "${var.project_name}-ecs-tasks-sg"
    environment = var.environment
  }
}

# This could alternately be configured for ANY traffic using the following
# resource "aws_security_group" "alb_sg" {
#   name   = "ecs-security-group"
#   description = "Allow inbound traffic for ECS tasks"
#   vpc_id = aws_vpc.ecs_vpc.id
#
#
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     self        = "false"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "any"
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#protocol-1
# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpPermission.html