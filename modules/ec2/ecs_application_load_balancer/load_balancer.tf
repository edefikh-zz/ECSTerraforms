resource "aws_alb" "main" {
  name            = "${var.app_name}-${var.environment}-alb"
  subnets         = ["${split(", ", (var.public_subnets))}"]
  security_groups = ["${var.alb_security_group_id}"]
  internal        = "false"
}
