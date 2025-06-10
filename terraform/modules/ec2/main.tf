resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups              = [var.sg_id]
  }

  user_data = filebase64("${path.module}/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-instance"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
