# Web Tier Launch Template  
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-template-"
  image_id      = var.ec2_ami
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web_sg.id]
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  user_data = base64encode(templatefile("data.sh", {
    internal_alb_dns = aws_lb.internal-alb.dns_name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.internal-alb]

  }

# Web Tier Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
  target_group_arns         = [aws_lb_target_group.external-alb-tg.arn]

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



