variable "subnet_ids" {}
variable "alb_sg_id" {}
variable "target_sg_id" {}
variable "target_port" {}
variable "vpc_id" {}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "java-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnet_ids

  tags = {
    Name = "java-app-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "java-app-tg-1"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# Listener (Port 80 only - no 8081)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  depends_on = [aws_lb_target_group.app_tg]
}

# Output DNS Name of ALB
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_alb.zone_id
}

resource "aws_lb_target_group" "metabase_tg" {
  name     = "metabase-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}
