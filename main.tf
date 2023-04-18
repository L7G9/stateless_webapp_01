terraform {
  cloud {
    organization = "LukeGregory-dev"
    workspaces {
      name = "aws-stateless-webapp"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_vpc" "stateless_webapp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "stateless_webapp_vpc"
  }
}

resource "aws_security_group" "stateless_webapp_instance" {
  name = "stateless-webapp-asg-instance"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.stateless_webapp_lb.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.stateless_webapp_lb.id]
  }

  vpc_id = aws_vpc.stateless_webapp_vpc.id
}

resource "aws_security_group" "stateless_webapp_lb" {
  name = "static-webapp-asg-instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.stateless_webapp_vpc.id
}

resource "aws_lb" "stateless_webapp_lb" {
  name               = "stateless-webapp-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stateless_webapp_lb.id]
}

resource "aws_lb_target_group" "stateless_webapp_lb_tg" {
  name      = "http"
  port      = 80
  protocol = "tcp"
  vpc_id    = aws_vpc.stateless_webapp_vpc.id

  health_check {
    port     = 80
    protocol = "tcp"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "stateless_webapp_lb_listenter" {
  load_balancer_arn = aws_lb.stateless_webapp_lb.id
  port              = 80
  protocol          = "tcp"

  default_action {
    target_group_arn = aws_lb_target_group.stateless_webapp_lb_tg.id
    type             = "forward"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    # update ???
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

# NOTE launch template prefered over launch configuation 
resource "aws_launch_configuration" "stateless_webapp_lc" {
  # creates unique name starting with value of name_prefix
  name_prefix     = "stateless-webapp-lc-"
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.stateless_webapp_instance.id]

  # ???
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "stateless_webapp_asg" {
  name                 = "statleless-webapp-asg"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.stateless_webapp_lc.name

  # add new instances in target group
  target_group_arns = [aws_lb_target_group.stateless_webapp_lb_tg.arn]

  # add tag to EC2 instances launched by this ASG
  tag {
    key                 = "Name"
    value               = "stateless-webapp-instance- from asg"
    propagate_at_launch = true
  }
}
