resource "aws_lb_target_group" "banking_customer_churn_tg" {
  name                 = "banking-customer-churn-tg"
  deregistration_delay = "300"
  port                 = 5000
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  target_type          = "ip"
  vpc_id               = local.vpc_id
  tags                 = local.tags

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/health-status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  depends_on = [aws_codebuild_project.banking_customer_churn_project]
}

resource "aws_lb_target_group" "banking_customer_churn_tg2" {
  name                 = "banking-customer-churn-tg2"
  deregistration_delay = "300"
  port                 = 5000
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  target_type          = "ip"
  vpc_id               = local.vpc_id
  tags                 = local.tags

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/health-status"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  depends_on = [aws_codebuild_project.banking_customer_churn_project]
}


resource "aws_lb" "banking_customer_churn_alb" {
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "banking-customer-churn-alb"
  security_groups            = ["sg-039a2f03d65350909"]

  subnets = local.subnets
  tags    = local.tags

  depends_on = [aws_lb_target_group.banking_customer_churn_tg]

}

resource "aws_lb_listener" "banking_customer_churn_lb_listener1" {
  load_balancer_arn = aws_lb.banking_customer_churn_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.banking_customer_churn_tg.arn
  }

  depends_on = [aws_lb.banking_customer_churn_alb]
}

resource "aws_lb_listener" "banking_customer_churn_lb_listener2" {
  load_balancer_arn = aws_lb.banking_customer_churn_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.banking_customer_churn_tg2.arn
  }

  depends_on = [aws_lb.banking_customer_churn_alb]
}

output "application_url" {
  value       = format("http://%s", aws_lb.banking_customer_churn_alb.dns_name)
  description = "Banking Customer Churn Application URL"
}