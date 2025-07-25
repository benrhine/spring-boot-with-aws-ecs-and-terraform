data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# GPT Data

# Get latest ECS-optimized Amazon Linux 2 AMI
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

