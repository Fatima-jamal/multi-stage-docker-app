resource "aws_autoscaling_group" "app_asg" {
  name                      = "java-app-asg"
  max_size                  = 3
  min_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "java-login-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
