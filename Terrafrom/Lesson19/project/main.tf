#------------------------------
# Task: Create main block for relation with modules
# 
# Created by Kevin Shindel
#------------------------------

# ------------- Provider -----------------------
provider "aws" {
  profile = "default"
  region = "eu-north-1"
}


# ------------- Modules -----------------------
module "vpc-default" {
#  source = "../modules/aws_network"
  source = "git@github.com:username/repository_name.git/aws_network" // remote modules from repository
  env = "development"
  vpc_cidr = "10.100.0.0/16"
  public_subnet_cidrs = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}

module "vpc-production" {
  source = "../modules/aws_network"
  env = "production"
  vpc_cidr = "10.10.0.0/16"
  public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24"]
}

# ------------- Outputs -----------------------
output "prod_public_subnet_ids" {
  value = module.vpc-production.public_subnet_ids # return outputs from module
}

output "prod_private_subnet_ids" {
  value = module.vpc-production.private_subnet_ids # return outputs from module
}

output "dev_public_subnet_ids" {
  value = module.vpc-default.public_subnet_ids # return outputs from module
}

output "dev_private_subnet_ids" {
  value = module.vpc-default.private_subnet_ids # return outputs from module
}