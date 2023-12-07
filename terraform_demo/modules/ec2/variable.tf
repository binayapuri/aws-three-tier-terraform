variable "ami_id" {
    type= string
    default = ""
    description = "AMI ID to deploy EC2 instance"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "type of instance to deploy"
}
variable "vpc_id" {
    type= string
    default = ""
    description = "VPC where we will create ec2 instance"
}
# variable "name" {
#     default = ["public_m1", "public_m2", "private_m1", "private_m2"]
# }

# variable "tags" {
#     type = map(string)
#     default = {}
#     description ="a map of tag to add all resources"
# }
variable "keypair" {
    default = "binay"
}
# variable "subnet_id"{
#     default = ""
#     type = string
#     description = "subnet ID"
# }

variable "public_subnet" {} 
# variable "private_subnet" {} 