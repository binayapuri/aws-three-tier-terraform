resource "aws_security_group" "ec2-sg"{
    name = "test-sg"
    description = "EC2 Security Group"
    vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "ec2-sg-http" {
    type = "ingress"
    security_group_id = aws_security_group.ec2-sg.id
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ec2-sg-https" {
    type = "ingress"
    security_group_id = aws_security_group.ec2-sg.id
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ec2-sg-ssh" {
    type = "ingress"
    security_group_id = aws_security_group.ec2-sg.id
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ec2-sg-egress" {
    type = "egress"
    security_group_id = aws_security_group.ec2-sg.id
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource  "aws_instance" "public_m1" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.public_subnet[0]
    key_name = var.keypair
    security_groups = [aws_security_group.ec2-sg.id]
    # iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        encrypted = true
    }
tags ={
    Name = "web-tier"
    Owner = "binay"

}
}


# resource  "aws_instance" "private_m1" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     subnet_id = var.private_subnet[0]
#     key_name = var.keypair
#     security_groups = [aws_security_group.ec2-sg.id]
#     # iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
#     root_block_device {
#         volume_size = 8
#         volume_type = "gp3"
#         encrypted = true
#     }
# tags = {
#     Name:"Application-tier"
#     OS:"Ubuntu"
# }
# # tags = merge(
# #     var.tags,
# #     {
# #         Name = var.name[2]
        
        
# #     }
# # )
# }


# resource  "aws_instance" "private_m2" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     subnet_id = var.private_subnet[1]
#     key_name = var.keypair
#     security_groups = [aws_security_group.ec2-sg.id]
#     # iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
#     root_block_device {
#         volume_size = 8
#         volume_type = "gp3"
#         encrypted = true
#     }
# tags = {
#     Name:"Application-tier"
#     OS:"Ubuntu"
# }
# # tags = merge(
# #     var.tags,
# #     {
# #         Name = var.name[3]
# #     }
# # )
# }