resource "aws_security_group" "metabase_sg" {
  name        = "${var.sg_name}-asg"
  description = "Allow traffic for Metabase and NGINX"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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
    Name = "${var.sg_name}-asg"
  }
}

resource "aws_launch_template" "metabase_lt" {
  name_prefix   = "metabase-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              docker run -d -p 3000:3000 --name metabase metabase/metabase
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo 'server {
                  listen 80;
                  location / {
                      proxy_pass http://localhost:3000;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }' > /etc/nginx/conf.d/metabase.conf
              systemctl restart nginx
            EOF
  )

  security_group_names = [aws_security_group.metabase_sg.name]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Metabase-ASG-Instance"
    }
  }
}

resource "aws_autoscaling_group" "metabase_asg" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.metabase_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Metabase-ASG-Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
