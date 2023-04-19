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

# get name using cli
# aws ec2 describe-images --region eu-west-2 --image-ids ami-0cd8ad123effa531a
# al2023-ami-2023.0.20230329.0-kernel-6.1-x86_64
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# create a vpc

# create a security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group
resource "aws_security_group" "web_server" {
  name        = "web-server"
  description = "Allow ssh, http & https inbound traffic and all outbound traffic"
  #vpc_id = optional, default vpc if omitted 

  tags = {
    Name = "allow-ssh-http-https"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "allow_shh" {
  security_group_id = aws_security_group.web_server.id

  description = "allow incomming ssh from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_server.id

  description = "allow incomming http from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.web_server.id

  description = "allow incomming https from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.web_server.id

  description = "allow all outgoing to anywhere"
  cidr_ipv4   = "0.0.0.0/0"

  ip_protocol = "-1"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]

  user_data = file("${path.module}/files/user-data.sh")

  tags = {
    Name = "swa-01-web-server"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "web_server" {
  instance = aws_instance.web_server.id
  vpc      = true

  tags = {
    Name = "swa-01-web-server-ip"
  }
}
