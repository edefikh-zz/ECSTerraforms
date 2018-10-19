resource "aws_security_group_rule" "ingress_http_alb" {
  description       = "allow http traffic to the LB"
  security_group_id = "${aws_security_group.alb.id}"
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "80"
  to_port   = "80"
  protocol  = "tcp"
}
