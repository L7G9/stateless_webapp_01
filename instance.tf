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

resource "aws_instance" "this" {
  ami = data.aws_ami.amazon_linux.id

  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = aws_subnet.this.id

  user_data = file("${path.module}${var.user_data_file}")

  tags = {
    Name = var.name_tag
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true

  tags = {
    Name = var.name_tag
  }
}
