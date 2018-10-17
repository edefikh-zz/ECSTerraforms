
resource "aws_elb" "elb" {
  name = "${var.app}-${var.environment}"
  subnets = ["${aws_subnet.1a-public.id}", "${aws_subnet.1e-public.id}"]
  internal = "${var.elb_is_internal}"
  security_groups = ["${aws_security_group.elb_security_group.id}"]

  listener {
    instance_port = "${var.backend_port}"
    instance_protocol = "${var.backend_protocol}"
    lb_port = 80
    lb_protocol = "http"
  }



  cross_zone_load_balancing = true
}

resource "aws_security_group" "elb_security_group" {
  name        = "elb_sg"
  description = "Used in the terraform"

  vpc_id = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
