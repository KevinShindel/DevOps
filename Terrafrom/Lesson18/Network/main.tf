#------------------------------
# Task: Terraform Remote State
# 
# Created by Kevin Shindel
#------------------------------

provider "aws" {
  profile = "default"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = []
}

#--------------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

data "aws_availability_zones" "this" {}

resource "aws_subnet" "this" {
  vpc_id = aws_vpc.this.id
  count = length(var.public_subnet_cidrs)
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
}

terraform {
  backend "s3" { # save Terraform at Remote Bucket
    bucket = "terraform-backend-bucket-2022"
    key = "dev/network/terrafrom.tfstate"
    region = "us-east-2"
  }
}


# -------------------------------------------
output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}