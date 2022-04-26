# DataSource https://www.terraform.io/language/data-sources

provider "aws" {
  profile = "default"
}

data "aws_availability_zones" "working" {} # provide data from AWS

data "aws_caller_identity" "current" {} #

data "aws_region" "current" {} # provide info about region

data "aws_vpcs" "this" {} # provide info about vpcs

data "aws_vpc" "prod_vpc" {  # provide info about vpc
#  tags = {
#    "Name" = "prod" # filter by tags
#  }

}

resource "aws_subnet" "this" {
  vpc_id = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block = "10.10.1.0/24"
  tags = {
    "Name": "Subnet_1 in ${data.aws_availability_zones.working.names[0]}"
    "Account": "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    "Region": data.aws_region.current.description
  }
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

output "aws_vpcs" {
  value = data.aws_vpcs.this.ids
}

output "aws_region_name" {
  value = data.aws_region.current.name # Show current AWS name
}

output "aws_region_desc" {
  value = data.aws_region.current.description # show current AWS Region Description
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names # show availability zones
}

output "data_aws_caller_id" {
  value = data.aws_caller_identity.current.account_id
}