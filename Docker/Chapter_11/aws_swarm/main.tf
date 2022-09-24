provider "aws" {
  profile = "default"
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

}

resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  vpc_id      = aws_default_vpc.this.id

  dynamic "ingress" {
    for_each = [22, 2377, 4789, 7946]
    content {
      to_port = ingress.value
      from_port = ingress.value
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "swarm_manager" {
  ami = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.this.id]
  instance_type = "t2.micro"
  key_name = "docker-key"
  user_data = file("docker-install.sh")


  tags = {
    Project: "Swarm"
    Terraform:  true
    Owner: "Kevin Shindel"
    Name: "Manager"
  }

}

resource "aws_instance" "swarm_nodes" {
  ami = data.aws_ami.ubuntu.id
  count = 3
  vpc_security_group_ids = [aws_security_group.this.id]
  instance_type = "t2.nano"
  key_name = "docker-key"
  user_data = file("docker-install.sh")

  tags = {
    Project: "Swarm"
    Terraform:  true
    Owner: "Kevin Shindel"
    Name: "Node # ${count.index + 1}"
  }
}

output "manager_ip" {
  value = "Manager IP: ${aws_instance.swarm_manager.public_ip}"
}

output "node_ip" {
  value = aws_instance.swarm_nodes[*].public_ip
}