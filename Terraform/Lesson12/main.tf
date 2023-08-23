#------------------------------
# Task: Set Variables instead hard-coded values
#
# Created by Kevin Shindel
# terrafrom plan -var="region=us-east-2" # change default variables
# terrafrom plan -var="instance_type=t3.micro" # change default variables
# export TF_VAR_region=us-west-2 # export in global envirement
#------------------------------

locals {
  fill_project_name = "${var.region}-${var.tags["Project"]}"
  location = var.region
}

provider "aws" {
  profile = "default"
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-*x86_64-gp2"]
  }

}

resource "aws_security_group" "default" {
  name = "AWS Security Group"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = var.cidr_block
    }
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = var.cidr_block
  }
}

resource "aws_instance" "this" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = merge(var.tags, {Description: "Server URL"})

}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  tags = merge(var.tags, local.fill_project_name)

}