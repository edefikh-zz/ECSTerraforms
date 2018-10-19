resource "aws_security_group_rule" "ingress_ssh_ec2_cidr" {
  description       = "allow access to the ec2 over ssh"
  security_group_id = "${aws_security_group.ec2.id}"
  type              = "ingress"

  cidr_blocks = "${split(", ", (var.CIDR_for_ssh))}"

  from_port = "22"
  to_port   = "22"
  protocol  = "tcp"
}
