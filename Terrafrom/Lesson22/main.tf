#------------------------------
# Task: new after v0.15
# 
# Created by Kevin Shindel
#------------------------------

variable "vpc_list" {
  default = []
}

resource "aws_vpc" "this" { # используя цикл
  for_each = var.vpc_list
  cidr_block = each.value // передать значение
}


variable "region" {
  type = string
  default = "eu-west-1"

  validation { # создаём валидацию на переменные
    condition = substr(var.region, 0, 3) == 'eu-' # только региноны в eu
    error_message = "must be an Europe Region line eu-xxx-x"
  }
}