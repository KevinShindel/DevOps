provider "aws" {
  profile = "default"
}

resource "aws_security_group" "default" {}

resource "aws_instance" "ubuntu" {
  count = 1
  ami = "ami-04505e74c0741db8d"
  instance_type = "t2.small"
  vpc_security_group_ids = [aws_security_group.default.id]
  tags = {
    "Name": "Ubuntu Instance"
    "Owner": "Kevin"
    "Project": "Terraform lesson"
    "terraform": "True"
  }
}