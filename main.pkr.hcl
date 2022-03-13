packer {
  required_plugins {
    amazon = {
      version = " >= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "packer-ansible-aws"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami    = "ami-0d527b8c289b4af7f"
  # source_ami_filter {
  #   filters = {
  #     name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  #     root-device-type    = "ebs"
  #     virtualization-type = "hvm"
  #   }
  #   most_recent = true
  #   owners      = ["099720109477"]
  # }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo useradd -m -s /bin/bash usera",
      "sudo useradd -m -s /bin/bash userb",
      "sudo useradd -m -s /bin/bash userc",
      "sudo useradd -m -s /bin/bash userd",
      "sudo usermod -aG sudo usera",
    ]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    host_alias    = "pierwszy"
  }
}