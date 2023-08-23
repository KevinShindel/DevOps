#------------------------------
# Task: Deploy servers with different regions
# 
# Created by Kevin Shindel
#------------------------------

provider "aws" { # create CANADA region provider
  alias = "canada" # if created more than one, need provide alias
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam:1234567890:role/RemoteAdministrator"
    session_name = "terraform_session"
  }
}


provider "aws" { # create USA region provider
  alias = "usa"
  region = "us-east-1"
}

provider "aws" { # create EUROPE region provider
  region = "eu-central-1"
  alias = "europe"
}

data "aws_ami" "europe_ubuntu" { # find AMI with selected provider
  owners = [""]
  provider = aws.europe
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu*"]
  }
}


resource "aws_instance" "ca_server" {
  provider = aws.canada
}

resource "aws_instance" "us_server" {
  provider = aws.usa
}

resource "aws_instance" "eu_server" {
  provider = aws.europe
  ami = data.aws_ami.europe_ubuntu.id # provide ami from data
}