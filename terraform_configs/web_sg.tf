# Creating Security Group 
resource "aws_security_group" "web_sg" {
    vpc_id = "${var.vpc_id}"
    name        = "web-sg"
    description = "Security group for web servers"
  
}

# Ingress rule to allow HTTP traffic from ALB Security Group
resource "aws_security_group_rule" "allow_http_from_alb" {  
    type                     = "ingress"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_sg.id
    source_security_group_id = aws_security_group.alb-sg.id
    description              = "Allow HTTP traffic from ALB SG"
}

# HTTPS traffic from ALB Security Group
resource "aws_security_group_rule" "allow_https_from_alb" {  
    type                     = "ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_sg.id
    source_security_group_id = aws_security_group.alb-sg.id
    description              = "Allow HTTPS traffic from ALB SG"
}

# SSH access from from anywhere
resource "aws_security_group_rule" "allow_ssh_from_anywhere" {  
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]        
    security_group_id = aws_security_group.web_sg.id
    description       = "Allow SSH access from anywhere"
}

# Egress rule to allow all outbound traffic
resource "aws_security_group_rule" "allow_all_outbound" {  
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.web_sg.id
    description       = "Allow all outbound traffic"
}   

