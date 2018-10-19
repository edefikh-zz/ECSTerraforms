resource "aws_security_group_rule" "ingress_icmp_ec2" {
  description       = "allow instances to ping resources inside VPC"
  security_group_id = "${aws_security_group.ec2.id}"
  type              = "ingress"

  cidr_blocks = ["${var.vpc_cidr}"]

  from_port = "-1"
  to_port   = "-1"
  protocol  = "icmp"
}
