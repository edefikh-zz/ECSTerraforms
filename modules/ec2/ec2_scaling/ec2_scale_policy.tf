resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.app_name}-${var.environment}_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${var.autoscaling_group_name}"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.app_name}-${var.environment}_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${var.autoscaling_group_name}"
}
