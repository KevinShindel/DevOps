#------------------------------
# Task: Count, for , if
# 
# Created by Kevin Shindel
#------------------------------

provider "aws" {
  profile = "default"
}

variable "aws_users" {
  description = "List of IAM User to create"
  default = ["Vasya", "Petya", "Olya", "Lena", "Masha", "Misha", "Vova"]
#  type = set(string)
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users) # count of aws-users
  name = element(var.aws_users, count.index) # return value of every aws_users
  depends_on = [var.aws_users]
}

resource "aws_instance" "servers" {
  count = 3 # create 3 instances
  instance_type = "t2.micro"
  ami = "ami-04505e74c0741db8d"
  tags = {
    Name = "Count of server: ${count.index + 1}" # paste counter into name tags
  }
}

output "created_aim_users_ids" {
  value = aws_iam_user.users[*].id # show ids for every created users
}

output "created_iam_users_custom" { # format string in loop
  value = [
    for user in aws_iam_user.users:
    "Username: ${user.name} has ARN: ${user.arn}"
  ]
}

output "create_iam_users_map" { # create map in loop
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id // "ASNDKJANSDKJNAD" : "vasya"
}
}

output "custom_if_len" { # filter users with 4 chars
  value = [
    for user in aws_iam_user.users:
          user.name
          if length(user.name) == 4
  ]
}

resource "aws_instance" "servers" {
    count = 3 # create 3 instances
  instance_type = "t2.micro"
  ami = "ami-04505e74c0741db8d"
}


output "server_all" {
  value = {
    for server in aws_instance.servers:
        server.id => server.public_ip // shows "" = ""
  }
}