#------------------------------
#
#
# Created by Kevin Shindel
#------------------------------

variable "region" {
  type = string
  default = "ca-central-1"
  description = "AWS region for deploy"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
  description = "Type of instance for deploy"
}

variable "cidr_block" {
  type = set(string)
  description = "IP White list"
  default = ["0.0.0.0/0"]
}

variable "allowed_ports" {
  type = set(string)
  description = "Allowed ports"
  default = ["22", "80", "443"]
}

variable "tags" {
  type = map(string)
  description = "Default tags"
  default = {
    Name = "Created by Terraform"
    Owner = "Kevin Shindel"
    Project = "Phoenix"
  }
}