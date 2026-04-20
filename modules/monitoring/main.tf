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

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-3-tier-app"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Web Tier CPU Utilization"
          view   = "timeSeries"
          period = 300
          stat   = "Average"
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.web_asg_name]
          ]
          annotations = {
            horizontal = [
              { value = 80, label = "Scale Up", color = "#ff0000" },
              { value = 20, label = "Scale Down", color = "#00ff00" }
            ]
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "App Tier CPU Utilization"
          view   = "timeSeries"
          period = 300
          stat   = "Average"
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.app_asg_name]
          ]
          annotations = {
            horizontal = [
              { value = 80, label = "Scale Up", color = "#ff0000" },
              { value = 20, label = "Scale Down", color = "#00ff00" }
            ]
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "ALB Request Count"
          view   = "timeSeries"
          period = 60
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.external_alb_arn_suffix]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "ALB Target Response Time (s)"
          view   = "timeSeries"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.external_alb_arn_suffix]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          title  = "RDS Database Connections"
          view   = "timeSeries"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_instance_identifier]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          title  = "RDS CPU Utilization"
          view   = "timeSeries"
          period = 60
          stat   = "Average"
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_identifier]
          ]
        }
      }
    ]
  })
}
