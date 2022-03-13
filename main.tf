terraform {
  required_version = "1.1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }

  }

  backend "s3" {
    bucket = "terraform-ppanter"
    key    = "terraform_010.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ubuntu" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ubuntu-sg.name]
}

data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["packer-ansible-aws-*"]
  }
  most_recent = true

  owners = ["699942661490"]
}

resource "aws_security_group" "ubuntu-sg" {
  name        = "allow-ssh"
  description = "Allow inbound SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["83.243.35.91/32"]

  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["83.243.35.91/32"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJzvAxVDYpP9JlVe3CTtf1rYdkmhHCdqolf/LFJ0kRO9FutFSnSiKJYumy5bZXeP5fNE6zrt2JSm7DJn/hyaRmxQyuCPqTJs4czo20whXLkmA6W/1xfZH6T62aPea4+eLRUw8Vk+2OZ2hyOzxiItCOyZMkA5rvdiOGcHq7TLKA0s4nHbuNMR+zC1Fwl8ECoG9PeuAdaDGH3OOMWtQ+CbxZrHEGtWXuA2XNrlxanfLplaWEuiL5aKAGyDPcRJ0ub5qezPfm37/tJM3V5dKw4xtZjR8QsdMVXFUpVCrHeYo8fV1E5WpMrfWf5M6AeMcfyY9pzKlaS4uzhMsbtQrxf7dJbov3HsNhYvRhM+gAYXTv+hDMIsbCuCnhJLGS0zIyyk7muUzgy+jL+Ij/U0WLb3mSClpgk0uX7ekK7boHmJlZmHskvlW9gvbKw1vz20B5zmhE0PNtjgMbdKn8MkbVSErXKPczBVQ7zhM1Ll+2/DIlmloKUXaPyTMVk6CJnG39H4c= admin"
}
