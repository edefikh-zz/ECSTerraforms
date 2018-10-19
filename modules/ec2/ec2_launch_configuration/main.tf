data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    app_name     = "${var.app_name}"
    environment  = "${var.environment}"
    aws_region   = "${var.aws_region}"
    cluster      = "${var.cluster}"
    s3_hostnames = "${var.s3_hostnames}"
  }
}

resource "aws_launch_configuration" "lc" {
  name_prefix                 = "${var.app_name}-${var.environment}-lc-"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  security_groups             = ["${var.ec2_security_groups}"]
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "true"
  user_data                   = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}
