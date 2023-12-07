#creating a load balancer
resource "aws_lb" "my_lb" {
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.alb-sg.id]
  subnets                     = [var.public_subnet1,var.public_subnet2 ]
  enable_deletion_protection  = false
  tags = {
  Name = "alb"
  }
  
}

#Creating a target group for load balancer
resource "aws_lb_target_group" "my-target-group" {
  
  name                  = "my-tg"
  port                  = 80
  protocol              = "HTTP"
  target_type           = "instance"
  vpc_id                = "${var.vpc_id}"
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
 }

#Creating a listener for ALB
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn   = aws_lb.my_lb.arn
  port                = 80
  protocol            = "HTTP"
  default_action {
    type = "forward"
    target_group_arn  = aws_lb_target_group.my-target-group.arn
  }
}
 
resource "aws_security_group" "alb-sg"{
    name = "alb-sg"
    description = "alb Security Group"
    vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "alb-sg-http" {
    type = "ingress"
    security_group_id = aws_security_group.alb-sg.id
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-sg-ssh" {
    type = "ingress"
    security_group_id = aws_security_group.alb-sg.id
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-sg-egress" {
    type = "egress"
    security_group_id = aws_security_group.alb-sg.id
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}