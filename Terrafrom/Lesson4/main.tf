# Build webserver during bootstrap

provider "aws" {
  profile = "default"
}

resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  name        = "WebServer Security Group"
  description = "Allow http/https traffic"
  vpc_id      = aws_default_vpc.this.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-064ff912f78e3e561"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data = templatefile("user_script.sh.tpl", {
    f_name = "Kevin",
    l_name = "Shindel",
    names = ["One", "Two", "Three"]
  })
  tags = {
    "Name": "Web server build by Terraform"
    "Owner": "kevin"
    "Project": "Terraform WebServer"
  }
}