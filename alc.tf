resource "aws_launch_configuration" "launch_config" {
  name = "${var.app}-${var.environment}-lc"
  image_id = "${lookup(var.ami_id, var.aws_region)}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "true"

  //iam_instance_profile = "iam_instance_profile.test_profile"

  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.alb-ec2.id}"]
  user_data = "${file(var.user_data)}"
}

resource "aws_autoscaling_group" "main_asg" {

  depends_on = ["aws_launch_configuration.launch_config"]

  name = "${var.app}-${var.environment}-asg"

    # The chosen availability zones *must* match the AZs the VPC subnets are tied to.
    // availability_zones = ["${lookup( var.availability_zones, "${var.aws_region}")}"]
    vpc_zone_identifier = ["${aws_subnet.1a-public.id}", "${aws_subnet.1e-public.id}"]

    # Uses the ID from the launch config created above
    launch_configuration = "${aws_launch_configuration.launch_config.id}"

    max_size = "${var.asg_number_of_instances}"
    min_size = "${var.asg_minimum_number_of_instances}"
    desired_capacity = "${var.asg_number_of_instances}"

    health_check_grace_period = "${var.health_check_grace_period}"
    health_check_type = "${var.health_check_type}"

    load_balancers = ["${aws_elb.elb.name}"]
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.role.name}"
}


resource "aws_iam_role" "role" {
  name = "iam-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.app}-${var.environment}"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_security_group" "alb-ec2" {
  name        = "ec2_sg"
  description = "Used in the terraform"

  vpc_id = "${aws_vpc.default.id}"

  # HTTP access from LB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_security_group.id}"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
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
