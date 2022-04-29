#------------------------------
# Task: Create Test/Production server
# 
# Created by Kevin Shindel
#------------------------------


# ///////////////////////////////////////
# ------------ Variables -----------------
# ///////////////////////////////////////
variable "public_key" {}
variable "private_key_path" {}
variable "ssh_key_name" {}


# ///////////////////////////////////////
# ------------ Data -----------------
# ///////////////////////////////////////
data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# ///////////////////////////////////////
# ------------ Provider -----------------
# ///////////////////////////////////////
provider "aws" {
  profile = "default"
}

# ///////////////////////////////////////
# ------------ Resources -----------------
# ///////////////////////////////////////
resource "aws_security_group" "this" {
  name           = "Dynamic Security Group"
  description    = "Dynamic ingress rules"

  dynamic "ingress" {
    for_each = ["22", "80", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
#  count           = 2
  ami             = data.aws_ami.latest_ubuntu.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name        = var.ssh_key_name
  instance_type   = "t2.micro"

    connection {
    user        = "ubuntu"
    type        = "ssh"
    port        = "22"
    host        = self.host_id
    private_key = file(var.private_key_path)
  }
}

# ///////////////////////////////////////
# ------------ Output -----------------
# ///////////////////////////////////////
output "server_url" {
  value = aws_instance.this.public_dns
}

#output "test_server_url" {
#  value = aws_instance.this[0].public_dns
#}
#
#output "test_production_url" {
#  value = aws_instance.this[1].public_dns
#}
