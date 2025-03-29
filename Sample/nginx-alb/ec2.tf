resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon-linux-2023.id
  associate_public_ip_address = true
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.keypair.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data                   = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y nginx
  systemctl start nginx
  systemctl enable nginx
  echo "${var.title}" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "wsi-web"
  }
}

data "aws_ami" "amazon-linux-2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*"]
  }
}

resource "aws_security_group" "web" {
  name        = "wsi-web-sg"
  description = "Allow SSH, HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "wsi"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "./wsi.pem"
}