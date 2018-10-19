resource "aws_autoscaling_group" "asg" {
  name                      = "${var.app_name}-${var.environment}-asg"
  vpc_zone_identifier       = ["${var.public_subnets}"]
  max_size                  = "${var.asg_ec2_max}"
  min_size                  = "${var.asg_ec2_min}"
  desired_capacity          = "${var.asg_ec2_desired}"
  force_delete              = true
  launch_configuration      = "${var.aws_launch_configuration_name}"
  target_group_arns         = ["${var.alb_target_group_arn}"]
  health_check_grace_period = "60"
  default_cooldown          = "400"
}
