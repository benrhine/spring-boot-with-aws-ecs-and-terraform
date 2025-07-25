

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  # Public b is only used in gpt-3 and example-1
  vpc_zone_identifier = [aws_subnet.public.id, aws_subnet.public_b.id]

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }

  # present in gpt-1, gpt-2, gpt-3
  lifecycle {
    create_before_destroy = true
  }

  # depends_on = [aws_subnet.public, aws_subnet.public_b, aws_launch_template.ecs_lt]
  #
  # force_delete = true
}