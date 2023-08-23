# autofill parameters for production
# for run terraform plan -var-file="prod.tfvars"
allowed_ports = ["80", "443"]
region = "us-east-1"
instance_type = "t3.small"
tags = {
    Name = "Created by Terraform"
    Owner = "Kevin Shindel"
    Project = "Phoenix"
}