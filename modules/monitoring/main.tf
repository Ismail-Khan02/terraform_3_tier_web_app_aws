resource "aws_cloudwatch_log_group" "web" {
  name              = "/aws/${var.environment}/3-tier-app/web"
  retention_in_days = 7

  tags = {
    Name        = "web-log-group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.environment}/3-tier-app/app"
  retention_in_days = 7

  tags = {
    Name        = "app-log-group"
    Environment = var.environment
  }
}

resource "aws_sns_topic" "alarms" {
  name = "${var.environment}-3-tier-app-alarms"

  tags = {
    Name        = "alarm-topic"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_autoscaling_policy" "web_scale_up" {
  name                   = "${var.environment}-web-scale-up"
  autoscaling_group_name = var.web_asg_name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_autoscaling_policy" "web_scale_down" {
  name                   = "${var.environment}-web-scale-down"
  autoscaling_group_name = var.web_asg_name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_autoscaling_policy" "app_scale_up" {
  name                   = "${var.environment}-app-scale-up"
  autoscaling_group_name = var.app_asg_name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_autoscaling_policy" "app_scale_down" {
  name                   = "${var.environment}-app-scale-down"
  autoscaling_group_name = var.app_asg_name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_high" {
  alarm_name          = "${var.environment}-web-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when web tier CPU exceeds 80% for 10 minutes"

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }

  alarm_actions = [aws_autoscaling_policy.web_scale_up.arn, aws_sns_topic.alarms.arn]

  tags = {
    Name        = "web-cpu-high-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_low" {
  alarm_name          = "${var.environment}-web-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Alarm when web tier CPU falls below 20% for 10 minutes"

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }

  alarm_actions = [aws_autoscaling_policy.web_scale_down.arn, aws_sns_topic.alarms.arn]

  tags = {
    Name        = "web-cpu-low-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${var.environment}-app-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when app tier CPU exceeds 80% for 10 minutes"

  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }

  alarm_actions = [aws_autoscaling_policy.app_scale_up.arn, aws_sns_topic.alarms.arn]

  tags = {
    Name        = "app-cpu-high-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_low" {
  alarm_name          = "${var.environment}-app-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Alarm when app tier CPU falls below 20% for 10 minutes"

  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }

  alarm_actions = [aws_autoscaling_policy.app_scale_down.arn, aws_sns_topic.alarms.arn]

  tags = {
    Name        = "app-cpu-low-alarm"
    Environment = var.environment
  }
}
