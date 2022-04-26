# Zero DownTime

variable "public_key" {}
variable "private_key" {}

provider "aws" {
  profile = "default"
}

resource "aws_security_group" "this" {
  name = "Dynamic Security Group"
  description = "Dynamic ingress rules"

  dynamic "ingress" { # construct dynamic for ingress
    for_each = ["80", "443", "8080", "22"] # list of ports
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

resource "aws_eip" "this" { # create Elastic IP
  instance = aws_instance.web_server.id
}

resource "aws_instance" "web_server" {
  ami = "ami-07f9348a1f678d4bc"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    "Name": "Web server build by Terraform"
    "Owner": "kevin"
    "Project": "Terraform WebServer"
  }

  connection {
    host = self.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file(var.private_key)
  }

    lifecycle { # select one of this
    prevent_destroy = true # protect from destroy server
    ignore_changes = ["ami", "user_data"] # protect from changes of select list of attrs
    create_before_destroy = true # create new instance between destroy old
  }
}

output "web_server_public_ip" { # outputs should be in separate file
  value = aws_eip.this.public_ip # after deploy show public ip
}