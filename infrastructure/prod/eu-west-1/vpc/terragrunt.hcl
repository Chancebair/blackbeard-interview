## Imports
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env = local.environment_vars.locals.environment
  aws_region = local.region_vars.locals.aws_region
}
# Normally this would reference a git tagged terraform modules repo
terraform {
  source = "../../../terraform_modules/vpc"
}
include {
  path = find_in_parent_folders()
}
##

## Inputs (the relevant bits)
inputs = {
    name = "apps-vpc"
    cidr = "10.0.0.0/16"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    enable_nat_gateway = true
}