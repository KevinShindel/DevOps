#------------------------------
# Task: Password generation
# Stage1: Generate password via random_string
# Stage2: create data storage for password
# Stage3: create data provider for extract password from data storage
# Stage4: Create DB MySQLv8.0 with generated password
#
# Created by Kevin Shindel
#------------------------------

provider "aws" {
  profile = "default"
  region = "ca-central-1"
}

variable "name" {
  default = "password"
}

resource "random_string" "rnd_pass" {
  length = 12
  special = true
  override_special = "!.#$"
  keepers = { # avoid for password asked
    keeper1= var.name
  }
}

resource "aws_ssm_parameter" "rds_password" { # AWS Systems Manager / Parameter Store

  name  = "/prod/mysql"
  description = "Master password for RDS MySQL"
  type  = "SecureString"
  value = random_string.rnd_pass.result # send result of execution
}

data "aws_ssm_parameter" "mysql_pass" {
  name = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password" {
  depends_on = [data.aws_ssm_parameter.mysql_pass]
  value = data.aws_ssm_parameter.mysql_pass
  sensitive = true
}

resource "aws_db_instance" "this" {
  instance_class = "db.t2.micro"
  identifier = "prod-rds"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  db_name = "prod"
  username = "administrator"
  password = data.aws_ssm_parameter.mysql_pass.value # use from SSM storage
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true
  apply_immediately = true
}