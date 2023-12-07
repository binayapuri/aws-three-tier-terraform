variable "vpc_cidr" {
    type = string
    default = ""
    description = "cidr of main_vpc"
 
}
variable "az" {
    # type = "string"
    default =["us-east-2a", "us-east-2b", "us-east-2c"]
    description = "Availability zone for subnets"
  
}
variable "public_subnet1" {
    type = string
    default = ""
    description = "public1 subnet for instance"
  
}
variable "public_subnet2" {
    type = string
    default = ""
    description = "public2 subnet for instance"
  
}
variable "private_subnet1" {
    type = string
    default = ""
    description = "private1 subnet for instance"
  
}
variable "private_subnet2" {
    type = string
    default = ""
    description = "private2 subnet for instance"
  
}
variable "private_subnet3" {
    type = string
    default = ""
    description = "private3 subnet for rds"
  
}
variable "private_subnet4" {
    type = string
    default = ""
    description = "private4 subnet for rds"  
}
