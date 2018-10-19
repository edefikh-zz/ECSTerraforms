resource "aws_security_group_rule" "egress_alb" {
  description       = "allow any traffic outside the LB"
  security_group_id = "${aws_security_group.alb.id}"
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
}
