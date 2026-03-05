# App Tier Launch Template
resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "app-launch-template-"
  image_id      = var.ec2_ami
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  user_data = base64encode(templatefile("app_data.sh", {
    aws_region = var.aws_region
    db_host = aws_db_instance.mydb.address
    db_name = var.db_name
  }))
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "app-server"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_db_instance.mydb]
  
}

# App Tier Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = var.app_asg_max_size
  min_size                  = var.app_asg_min_size
  desired_capacity          = var.app_asg_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300 
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.application-subnet-1.id, aws_subnet.application-subnet-2.id]
  target_group_arns         = [aws_lb_target_group.internal-alb-tg.arn]

  tag {
    key                 = "Name"
    value               = "app-server-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true

  }
}

