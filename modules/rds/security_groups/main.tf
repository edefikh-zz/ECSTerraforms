resource "aws_security_group" "rds" {
  name        = "${var.app_name}-${var.environment}-rds-sg"
  description = "RDS instance security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.app_name}-${var.environment}-rds-sg"
  }
}
