# Launch template for ECS EC2 instance
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-ec2-"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.alb_sg.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
EOF
  )
}

# an alternate implementation from example 1

# resource "aws_launch_template" "ecs_lt" {
#   name_prefix   = "ecs-ec2-"
#   image_id      = data.aws_ami.ecs_ami.id
#   instance_type = "t3.micro"
#
#   # used my previous key
#  # key_name               = "brr-test"
#  # vpc_security_group_ids = [aws_security_group.ecs_sg.id]
#
#   iam_instance_profile {
#     name = aws_iam_instance_profile.ecs_instance_profile.name
#   }
#
#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 30
#       volume_type = "gp2"
#     }
#   }
#
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "ecs-instance"
#     }
#   }
#
#   user_data = filebase64("${path.module}/ecs.sh")
# }