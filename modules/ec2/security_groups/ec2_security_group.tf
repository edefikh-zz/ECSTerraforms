resource "aws_security_group" "ec2" {
  name        = "${var.app_name}-${var.environment}-ec2-sg"
  description = "EC2 instance security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.app_name}-${var.environment}-ec2-sg"
  }
}
