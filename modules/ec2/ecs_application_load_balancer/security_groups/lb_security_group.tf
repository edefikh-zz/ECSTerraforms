resource "aws_security_group" "alb" {
  name        = "${var.app_name}-${var.environment}-alb-sg"
  description = "ALB security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.app_name}-${var.environment}-alb-sg"
  }
}
