#------------------------------
# Task: Restart selected server
# terrafrom apply -replace  aws_instance.node2 // redeploy only this instance
# Created by Kevin Shindel
#------------------------------

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

provider "aws" {
  profile = "default"
  region = "us-west-1"
}

resource "aws_instance" "node1" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Node 1"
    Owner = "Kevin Shindel"
  }
}

resource "aws_instance" "node2" { # если нужно этот сервак пересоздать
  ami = data.aws_ami.latest_ubuntu.id    # terrafrom apply -replace  aws_instance.node2
  instance_type = "t2.micro"
  tags = {
    Name = "Node 2"
    Owner = "Kevin Shindel"
  }

}

resource "aws_instance" "node3" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Node 3"
    Owner = "Kevin Shindel"
  }
  depends_on = [aws_instance.node2]
}
