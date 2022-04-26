# Dynamic Ingresse rules

provider "aws" {
  profile = "default"
}

resource "aws_security_group" "this" {
  name = "Dynamic Security Group"
  description = "Dynamic ingress rules"

  dynamic "ingress" { # construct dynamic for ingress
    for_each = ["80", "443", "8080"] # list of ports
    content {
    from_port = ingress.value # forloop in for_each
    protocol  = "tcp"
    to_port   = ingress.value  # forloop in for_each
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform": "true"
  }

}