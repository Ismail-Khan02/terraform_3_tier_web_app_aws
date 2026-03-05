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
    db_host = aws_db_instance.mydb.address
    db_user = var.db_username
    db_pass = var.db_password
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
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
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

