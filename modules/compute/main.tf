resource "aws_launch_template" "web" {
  name_prefix   = "${var.environment}-web-launch-template-"
  image_id      = var.ec2_ami
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.web_sg_id]
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/data.sh", {
    internal_alb_dns = var.internal_alb_dns
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "web-server"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "${var.environment}-web-asg"
  max_size                  = var.web_asg_max_size
  min_size                  = var.web_asg_min_size
  desired_capacity          = var.web_asg_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.web_subnet_ids
  target_group_arns         = [var.external_alb_tg_arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-launch-template-"
  image_id      = var.ec2_ami
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.app_sg_id]
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/app_data.sh", {
    aws_region = var.aws_region
    db_host    = var.db_address
    db_name    = var.db_name
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
}

resource "aws_autoscaling_group" "app" {
  name                      = "${var.environment}-app-asg"
  max_size                  = var.app_asg_max_size
  min_size                  = var.app_asg_min_size
  desired_capacity          = var.app_asg_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.application_subnet_ids
  target_group_arns         = [var.internal_alb_tg_arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

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
