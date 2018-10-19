resource "aws_security_group_rule" "ingress_https_alb" {
  description       = "allow https traffic to the LB"
  security_group_id = "${aws_security_group.alb.id}"
  type              = "ingress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "443"
  to_port   = "443"
  protocol  = "tcp"
}
