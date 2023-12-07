output "target_group_arn" {
    description             = "amazon resource name for the target group"
    value                   = aws_lb_target_group.my-target-group.arn
}
# output "elb_id" {
#     description             = "elb"
#     value                   = aws_lb.my_lb.id
# }
output "security_group" {
    value = aws_security_group.alb-sg.id 
}