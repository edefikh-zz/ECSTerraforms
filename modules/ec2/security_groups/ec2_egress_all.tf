resource "aws_security_group_rule" "egress_ec2" {
  description       = "allow the ec2 access to web"
  security_group_id = "${aws_security_group.ec2.id}"
  type              = "egress"

  cidr_blocks = ["0.0.0.0/0"]

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
}
