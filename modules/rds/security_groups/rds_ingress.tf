resource "aws_security_group_rule" "ingress_rds_from_ec2" {
  description       = "allow access to the RDS from clusters ec2"
  security_group_id = "${aws_security_group.rds.id}"
  type              = "ingress"

  source_security_group_id = "${var.source_security_group_id}"

  from_port = "${lookup(var.db_port, var.db_engine)}"
  to_port   = "${lookup(var.db_port, var.db_engine)}"
  protocol  = "tcp"
}
