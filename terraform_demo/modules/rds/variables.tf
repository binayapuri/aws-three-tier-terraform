variable "instance_class" {
  type = string
  default = ""
  description = "RDS instance type"

}
variable "storage" {
    type = string
    default = ""
    description = "allocated storage of my rds"
  
}
variable "engine_type"{
    type = string
    default = ""
    description = "type of my engine"
}
variable "engine_version"{
    type = string
    default = ""
    description = "mysql engine version"
}
variable "db_user_name" {
    type = string
    default = "binay"
    description = "username of database"
  
}
variable "db_password" {
    type = string
    default = "password"
    description = "password for user"
}
variable "vpc_id" {
    type= string
    default = ""
    description = "VPC where we will create ec2 instance"
}
variable "security_group" {
    type = string
}

variable "private_subnet" {}

variable "standby_rds" {
    default = true
    type = bool
}