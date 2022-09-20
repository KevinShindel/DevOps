variable "private_key_path" {
  type = string
  default = "~/.ssh/docker-key.pem"
}

provider "aws" {
  profile = "default"
  region = "eu-west-2"
}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  vpc_id      = aws_default_vpc.this.id

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "this" {
  count                  = 2
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.nano"
  vpc_security_group_ids = [aws_security_group.this.id]
  tags                   = {
    "Name" : "Ubuntu instance ${count.index + 1}"
    Owner : "Kevin Shindel"
    Project : "Docker Ambassador"
    terraform : true
  }
  connection {
    user = "ec2-user"
    type = "ssh"
    port = "22"
    host = self.host_id
    private_key = file(var.private_key_path)
  }

}

output "instance_public_url" {
  value = aws_instance.this[*].public_ip
}
