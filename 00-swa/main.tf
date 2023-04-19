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

resource "aws_internet_gateway" "stateless_webapp_gw" {
  vpc_id = aws_vpc.stateless_webapp_vpc.id
}


resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.stateless_webapp_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.stateless_webapp_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.stateless_webapp_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2c"
  tags = {
    Name = "subnet3"
  }
}

resource "aws_security_group" "stateless_webapp_instance" {
  name = "stateless-webapp-asg-instance"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

resource "aws_security_group" "stateless_webapp_lb" {
  name = "stateless-webapp-lb"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
}

resource "aws_lb_target_group" "stateless_webapp_lb_tg" {
  name     = "http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stateless_webapp_vpc.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "stateless_webapp_lb_listenter" {
  load_balancer_arn = aws_lb.stateless_webapp_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.stateless_webapp_lb_tg.id
    type             = "forward"
  }
}

# NOTE launch template prefered over launch configuation
resource "aws_launch_configuration" "stateless_webapp_lc" {
  # creates unique name starting with value of name_prefix
  name_prefix     = "stateless-webapp-lc-"
  image_id        = "ami-0cd8ad123effa531a"
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

  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  # add new instances in target group
  target_group_arns = [aws_lb_target_group.stateless_webapp_lb_tg.arn]

  # add tag to EC2 instances launched by this ASG
  tag {
    key                 = "Name"
    value               = "stateless-webapp-instance- from asg"
    propagate_at_launch = true
  }
}
