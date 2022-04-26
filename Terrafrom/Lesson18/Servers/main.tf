#------------------------------
# Task:
# 
# Created by Kevin Shindel
#------------------------------

provider "aws" {
  profile = "default"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-backend-bucket-2022"
    key = "dev/network/terrafrom.tfstate"
    region = "us-east-2"
  }
}

resource "aws_security_group" "this" {
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks =[data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }
}

output "network_state" {
  value = data.terraform_remote_state.network
}