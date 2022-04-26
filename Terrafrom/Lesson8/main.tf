# Instance Dependencies on DataBase creation/destroy

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
  instance = aws_instance.frontend_server.id
}

resource "aws_instance" "frontend_server" {
  ami                    = "ami-07f9348a1f678d4bc"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    "Name" : "Web server FrontEnd build by Terraform"
    "Owner" : "kevin"
    "Project" : "Terraform WebServer"
  }
  depends_on = [aws_instance.database_server] # creates only after DB
}


resource "aws_instance" "backend_server" {
  ami                    = "ami-07f9348a1f678d4bc"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    "Name" : "Web server Backend build by Terraform"
    "Owner" : "kevin"
    "Project" : "Terraform WebServer"
  }
  depends_on = [aws_instance.database_server] # creates only after DB
}

resource "aws_instance" "database_server" {
  ami                    = "ami-07f9348a1f678d4bc"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    "Name" : "Web server Database build by Terraform"
    "Owner" : "kevin"
    "Project" : "Terraform WebServer"
  }
}