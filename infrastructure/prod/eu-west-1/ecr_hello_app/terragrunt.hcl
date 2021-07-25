### Type: ECR Repository
### Description: ECR repo for the hello-app images

## Imports
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env = local.environment_vars.locals.environment
  aws_region = local.region_vars.locals.aws_region
}
# Normally this would reference a git tagged terraform modules repo
# example: source = "git@github.com:hashicorp/ecr?ref=v1.2.0"
terraform {
  source = "../../../terraform_modules/ecr"
}
include {
  path = find_in_parent_folders()
}

## Inputs (the relevant bits)
inputs = {
    name = "hello-app-${local.aws_region}"
}