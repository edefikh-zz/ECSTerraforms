resource "aws_alb_target_group" "target_group" {
  name                 = "${var.app_name}-${var.environment}-tg"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "60"

  health_check {
    interval            = "30"
    path                = "/"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "10"
    protocol            = "HTTP"
    matcher             = "200,301,302"
  }

  depends_on = ["aws_alb.main"]
}
