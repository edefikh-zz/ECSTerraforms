resource "aws_alb_listener" "frontend_https" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ssl_certificate}"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  count             = "${var.ssl_certificate != ""  ? 1 : 0}"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.id}"
    type             = "forward"
  }

  depends_on = ["aws_alb.main"]
}
