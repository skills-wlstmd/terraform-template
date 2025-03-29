resource "aws_alb" "main" {
  name            = "wsi-alb"
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets         = [for id in data.aws_subnets.default.ids : id]
}

resource "aws_security_group" "alb" {
  name        = "wsi-alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_alb_target_group" "main" {
  name        = "wsi-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
  }
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_alb_target_group.main.arn
  target_id        = aws_instance.web.id
  port             = 80
}