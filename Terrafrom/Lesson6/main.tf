# Zero DownTime

variable "public_key" {}
variable "private_key_path" {}
variable "ssh_key_name" {}

provider "aws" {
  profile = "default"
}

resource "aws_security_group" "this" {
  name = "Dynamic Security Group"
  description = "Dynamic ingress rules"

  dynamic "ingress" { # construct dynamic for ingress
    for_each = ["80", "443", "22"] # list of ports
    content {
    from_port = ingress.value # forloop in for_each
    protocol  = "tcp"
    to_port   = ingress.value  # forloop in for_each
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform": "true"
  }

}

resource "aws_eip" "this" { # create Elastic IP
  instance = aws_instance.web_server.id
}

resource "aws_instance" "web_server" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name = var.ssh_key_name

  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Kevin",
    l_name = "Shindel",
    names = ["One", "Two", "Three"]
  })

  tags = {
    "Name": "Web server build by Terraform"
    "Owner": "kevin"
    "Project": "Terraform WebServer"
  }

    connection {
    user = "ec2-user"
    type = "ssh"
    port = "22"
    host = self.host_id
    private_key = file(var.private_key_path)
  }

#    lifecycle { # select one of this
#    prevent_destroy = true # protect from destroy server
#    ignore_changes = ["ami", "user_data"] # protect from changes of select list of attrs
#    create_before_destroy = true # create new instance between destroy old
#  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = var.public_key
}

output "instance_public_url" {
  value = aws_eip.this.public_ip
}

