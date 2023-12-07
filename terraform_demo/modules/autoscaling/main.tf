# Create launch template
resource "aws_launch_template" "as_template" {
  name         = "as_template"
  image_id     = var.image_id
  instance_type = var.instance_type
  key_name     = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_groups]
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  sudo apt update
  sudo apt install -y apache2

  # Create index.html with the hostname
  sudo tee /var/www/html/index.html > /dev/null <<'HTML'
  <h1>Hello World from \$(hostname -f)</h1>
  HTML

  sudo systemctl start apache2
  sudo systemctl enable apache2
  EOF
  )
}

#create a autoscaling group
resource "aws_autoscaling_group" "as-autoscaling" {
  name = "as-autoscaling"
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  health_check_grace_period = 300
  health_check_type = "ELB"
  vpc_zone_identifier = [var.subnet_id[0],var.subnet_id[1]]

  launch_template {
    id      = aws_launch_template.as_template.id
    version = "$Latest"
  }

  target_group_arns = [ ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
   tags= [{
    key = "Name"
    value = "Application-tier"
    propagate_at_launch = true
}]
}
#scale up policy
resource "aws_autoscaling_policy" "as-scaleup" {
  name                   = "as-scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.as-autoscaling.name
}
#scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "as-scaleup-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as-autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.as-scaleup.arn]
}
#scale down policy
resource "aws_autoscaling_policy" "as-scaledown" {
  name                   = "as-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.as-autoscaling.name
}
#scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "as-scaledown-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as-autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.as-scaledown.arn]
}
#Attachment of target group and autoscaling
resource "aws_autoscaling_attachment" "as-attach" {
    autoscaling_group_name              = aws_autoscaling_group.as-autoscaling.id
    alb_target_group_arn                 = var.target_group_arn
    # policy_arn                          = aws_autoscaling_policy.as_policy.arn
}
