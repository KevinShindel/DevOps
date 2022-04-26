#------------------------------
# Task: Terraform Conditions and Lookups
# 
# Created by Kevin Shindel
#------------------------------
variable "env" {
  default = "stage"
}

variable "prod_owner" {
  default = "Kevin Shindel"
}
variable "prod_no_owner" {
  default = "Dyadya Vasya"
}

variable "ec2_size" {
  default = {
    "prod" = "t3.medium"
    "dev" = "t3.micro"
    "stage" = "t3.small"
  }
}

variable "allow_ports" {
  default = {
    "prod": ["80", "443"],
    "stage": ["22", "80", "443"],
    "dev": ["22", "80", "443", "8080"],
  }
}

provider "aws" {
  profile = "default"
}


resource "aws_instance" "server" {
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"
  count = var.env == "prod" ? 1 : 0 # if production create instanse else no
  ami = ""
  tags = {
    Name = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.prod_no_owner
  }
}

resource "aws_security_group" "this" {

    dynamic "ingress" {
    for_each = lookup(var.allow_ports, var.env)
    content {
      to_port = ingress.value
      from_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server2" {
  ami = "ami-04505e74c0741db8d"
  instance_type = lookup(var.ec2_size, var.env)
  #  instance_type = var.env == 'prod' ? var.ec2_size['prod'] : var.ec2_size['dev']
  security_groups = [aws_security_group.this.id]

}