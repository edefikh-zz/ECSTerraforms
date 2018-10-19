resource "aws_security_group_rule" "ingress_from_lb_to_ec2" {
  description       = "allow ALB target groups to route requests to container ports running in ec2"
  security_group_id = "${var.ec2_security_group}"
  type              = "ingress"

  source_security_group_id = "${aws_security_group.alb.id}"

  from_port = "0"
  to_port   = "65535"
  protocol  = "tcp"
}
