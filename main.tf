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

# Create a VPC
resource "aws_vpc" "stateless_webapp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "stateless_webapp_vpc"
  }
}

# Create security group letting in http traffic from anywhere
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

# Create an application load balancer
#resource "aws_alb" "name" {

#}

# Create an auto scalling group
