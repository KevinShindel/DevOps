#------------------------------
# Task: Execution commands
#
# Created by Kevin Shindel
#------------------------------

resource "null_resource" "command1" { # just echo in file
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" { # execution bash command
  provisioner  "local-exec" {
    command = "ping -c 5 1.1.1.1"
  }
}

resource "null_resource" "command3" { # execution python code
  provisioner "local-exec" {
    command = "print('hello world!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command4" { # execution bash with env
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Petia"
      NAME3 = "Gala"
    }
  }
}

resource "null_resource" "command6" {
  # depend on other commands
  provisioner "local-exec" {
    command = "echo 'Done at $(date)' > log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4]
}

resource "aws_instance" "server" {
  depends_on = [null_resource.command6]
  provisioner "local-exec" {
    command = "echo 'Hello from instance'"
  }
}