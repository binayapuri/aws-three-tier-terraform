#Output from VPC module
output "vpc-id" {
    value= module.vpc.vpc_id
  
}
output "public_subnets" {
  value = module.vpc.public_subnet
}
output "private_subnets" {
  value = module.vpc.private_subnet
}

#Output from EC2 module
# output "security_group" {
#     value = module.ec2.security_group
# }

# #Output from RDS module
# output "rds-securitygroup"{
#     value = module.rds.rds-sg
# }

#Output from ALB
output "Tg-arn"{
    value = module.elb.target_group_arn
}