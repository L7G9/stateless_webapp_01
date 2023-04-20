resource "aws_security_group" "this" {
  description = "Allow ssh, http & https inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = var.name_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_shh" {
  security_group_id = aws_security_group.this.id

  description = "allow incomming ssh from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name = var.name_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.this.id

  description = "allow incomming http from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = {
    Name = var.name_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.this.id

  description = "allow incomming https from anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443

  tags = {
    Name = var.name_tag
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.this.id

  description = "allow all outgoing to anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = {
    Name = var.name_tag
  }
}
