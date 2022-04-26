# --------------------------------------------
# Task: Green/Blue deployment
# Create:
#       - Security Group for Web Server
#       - Launch configuration with Auto AMI Lookup
#       - Auto Scaling Group using 2 Availability Zones
#       - Classic Load Balance in 2 Availability Zones
#
# Made by Kevin Shindel
#---------------------------------------------

variable "public_key" {} # for ssh public key
variable "private_key" {} # for private AWS key

provider "aws" {
  profile = "default"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_nginx" { # Search fresh AMI
  owners = ["679593333241"]
  most_recent = true
  filter {
    name   = "name"
    values = ["bitnami-nginx-*"]
  }
}

resource "aws_security_group" "this" {
  name = "Dynamic Security Group"

  dynamic "ingress" { # dynamical create ingress config
    for_each = ["80", "443", "22"]
    content {
      to_port = ingress.value
      from_port = ingress.value
      protocol = "tcp"
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

resource "aws_launch_configuration" "this" { # instead aws_instance
  name_prefix = "Server Highly-Available-LC-"
  image_id         =  "ami-0fb653ca2d3203ac1"
  instance_type    = "t3.micro"
  security_groups  = [aws_security_group.this.id]

  user_data = templatefile("user_data.sh.tpl", { # userdata for custom commands for instances
    f_name = "Kevin",
    l_name = "Shindel",
    names = ["One", "Two", "Three"]
  })

  lifecycle { # create new instance before delete old
    create_before_destroy = true
  }

  connection { # connection block -> need to connect ssh via console
    type = "ssh"
    user = "ec2-user"
    host = self.id
    key_pair = file(var.private_key)
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix = "ASG-${aws_launch_configuration.this.name}"
  launch_configuration = aws_launch_configuration.this.name
  max_size = 2
  min_size = 2
  min_elb_capacity = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.availability_zone_1.id,
                         aws_default_subnet.availability_zone_2.id]
  load_balancers = [aws_elb.this.name]

  dynamic "tag" {
    for_each = {
      Name = "Webserver in ASG"
      Owner = "Kevin Shindel"
      Terraform = true
    }
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_elb" "this" {
  name = "Server-HA-ELB"
  availability_zones = data.aws_availability_zones.available.names
  security_groups = [aws_security_group.this.id]

  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  tags = {
    Name = "WebServer-HA-ELB"
    Owner = "Kevin Shindel"
  }
}

resource "aws_default_subnet" "availability_zone_1" { #
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "availability_zone_2" { #
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_key_pair" "this" { #
  key_name   = "aws_key"
  public_key = file(var.public_key)
}
