
resource "aws_lb" "external-alb" {
    name               = "external-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb-sg.id]
    subnets            = [
        aws_subnet.public-subnet-1.id
    ]
    
    enable_deletion_protection = false
    
    tags = {
        Name        = "external-alb"
        Environment = var.environment
    }
  
}

resource "aws_lb_target_group" "external-alb-tg" {
    name     = "external-alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200-399"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name        = "external-alb-tg"
        Environment = var.environment
    }
  
}

resource "aws_lb_target_group_attachment" "attachment" {
    target_group_arn = aws_lb_target_group.external-alb-tg.arn
    target_id        = aws_instance.web_server.id
    port             = 80

    depends_on = [ aws_instance.web_server ]
  
}


resource "aws_lb_listener" "external-alb-listener" {
    load_balancer_arn = aws_lb.external-alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.external-alb-tg.arn
    }
  
}

