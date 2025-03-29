# ALB Load Balancer
resource "aws_lb" "alb" {
  name = "<env>-alb"
  internal = false # Internet-facing
#   internal = true # internal
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id] # Public
#   subnets = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id] # Private

  tags = {
      Name = "<env>-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "alb-tg"{
  name = "<env>-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id  = aws_vpc.main.id
  target_type = "instance"
  
  health_check {
    path = "<Path>"
    protocol = "HTTP"
    healthy_threshold  = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }

  tags = {
      Name = "<env>-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "app-alb-listner"{
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

# resource "aws_instance" "app" {
#   ami           = "<ami-id>" # 사용할 AMI ID
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_a.id
#   security_groups = [aws_security_group.alb.id]

#   tags = {
#     Name = "<env>-app-instance"
#   }

#   user_data = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y httpd
#     systemctl start httpd
#     systemctl enable httpd
#     echo "Hello from <env>-app-instance" > /var/www/html/index.html
#   EOF
# }

# ALB Attach Server
resource "aws_lb_target_group_attachment" "internal-alb-attach-resource"{
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id = aws_instance.app.id
  port = 80
  depends_on = [aws_lb_listener.app-alb-listner]
}

# Security Group
resource "aws_security_group" "alb" {
  name = "<env>-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }
 
    tags = {
    Name = "<env>-alb-sg"
  }
}

output "ALB-SG" {
    value = aws_security_group.alb.id
}

output "ALB" {
    value = aws_lb.alb.id
}