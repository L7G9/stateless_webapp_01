terraform {
  cloud {
    organization = "LukeGregory-dev"
    workspaces {
      name = "swa-01"
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

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "web_server" {
  ami = "ami-0cd8ad123effa531a"
  instance_type = "t2.micro"

  user_data = file("${path.module}/files/user-data.sh")

  tags = {
    Name = "swa-01-web-server"
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "web_server" {
  instance = aws_instance.web_server.id
  vpc      = true

  tags = {
    Name = "swa-01-web-server-ip"
  }
}
