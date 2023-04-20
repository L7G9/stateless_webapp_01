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
  ami                    = data.aws_ami.amazon_linux.id
  
  # variable
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = aws_subnet.this.id

  # variable
  user_data = file("${path.module}/files/user-data.sh")

  tags = {
    Name = "swa_01_instance"
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true

  tags = {
    Name = "swa_01_eip"
  }
}
