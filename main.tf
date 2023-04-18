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
  name = "stateless_webapp_vpc"
  cidr_block = "10.0.0.0/16"

  azs = ["eu-west-2a"]

  tags = {
    Name = "stateless_webapp_vpc"
  }
}

resource "aws_security_group" "stateless_webapp_instance" {
  name = "stateless-webapp-asg-instance"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.stateless_webapp_lb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.stateless_webapp_lb.id]
  }

  vpc_id = aws_vpc.stateless_webapp_vpc.id  
}

resource "aws_security_group" "stateless_webapp_lb" {
  name = "static-webapp-asg-instance"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.stateless_webapp_vpc.id
}

resource "aws_launch_configuration" "stateless_webapp_lc" {
  name_prefix = "stateless-webapp-"
  image_id = "???"
  instance_type = "t2.micro"
  user_data = file("user-data.sh")
  security_groups = [aws_security_group.stateless_webapp_insatnce.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscalling_group" "stateless_webapp_asg" {
  name = "statleless-webapp-asg"
  min_size = 1
  max_size = 3
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.stateless_webapp_lc.name
  vpc_zone_identifier = ???
}
