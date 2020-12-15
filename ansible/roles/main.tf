locals {
  vpc_id           = "vpc-0b9e436553e9876f8"
  subnet_id        = "subnet-0b21f4d9b6aa5e444"
  ssh_user         = "ubuntu"
  key_name         = "ansible_devops"
  private_key_path = "./ansible_devops.pem"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "nginx" {
  name   = "nginx"
  vpc_id = local.vpc_id

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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = "ami-07dd19a7900a1f049"
  subnet_id                   = "subnet-0b21f4d9b6aa5e444"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = local.key_name
  user_data                   = file("apache.sh")

  tags = {
    Name = "nginx"
  }
}
