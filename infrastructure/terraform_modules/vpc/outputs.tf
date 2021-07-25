output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet"
  value       = module.vpc.public_subnets
}