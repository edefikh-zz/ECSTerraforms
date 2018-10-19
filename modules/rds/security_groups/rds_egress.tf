resource "aws_security_group_rule" "egress_rds" {
  description       = "allow the RDS access to outside"
  security_group_id = "${aws_security_group.rds.id}"
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
}
