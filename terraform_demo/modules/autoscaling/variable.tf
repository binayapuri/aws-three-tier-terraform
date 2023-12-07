variable "key_name" {
    type = string
    default = "binay"
}
variable "image_id" {
    default = "ami-0e83be366243f524a"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "security_groups"{}
variable "subnet_id" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "lb_subnets" {}
variable "target_group_arn" {} 
# variable"elb_id"{}
