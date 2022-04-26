# Auto-search info about AMI ID
provider "aws" {
  profile = "default"
}


# Canonical, Ubuntu, 20.04 LTS, ...read more
# ami-0fb653ca2d3203ac1
# 1. Search manualy for AMI on Amazon COnsole
# 2. Go to Images -> AMI -> paste founded ami
# 3. Look for name and owner
# 4. Fill filter and attrs for data

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*x86_64-gp2"]
  }
}

data "aws_ami" "latest_windows" {
  owners = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

output "aws_latest_windows_ami" {
  value = data.aws_ami.latest_windows.id
}

output "aws_latest_windows_name" {
  value = data.aws_ami.latest_windows.name
}

output "aws_ubuntu_ami" {
  value = data.aws_ami.latest_ubuntu.id
}

output "aws_ubuntu_name" {
  value = data.aws_ami.latest_ubuntu.name
}


output "aws_amazon_ami" {
  value = data.aws_ami.latest_amazon.id
}

output "aws_amazon_name" {
  value = data.aws_ami.latest_amazon.name
}