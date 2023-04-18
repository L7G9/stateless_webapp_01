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
