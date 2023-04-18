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

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.stateless_webapp_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stateless_webapp_sg_allow_http"
  }
}

#resource "aws_alb" "name" {

#}

resource "aws_launch_template" "stateless_webapp_lt" {
  name_prefix = "stateless_webapp_lt"
  image_id = "ami-???"
  instance_type = "t2.micro" 

  tags = {
    Name = "stateless_web_lt"
  }
}

resource "aws_autoscaling_group" "stateless_webapp_asg" {
  availability_zones = ["eu-west-2a"]
  desired_capacity = 1
  max_size = 2
  min_size = 1

  launch_template {
    id = aws_launch_template.stateless_webapp_lt.id
    version = "$Latest"
  }

  tags = {
    Name = "stateless_webapp_asg"
  }
}
