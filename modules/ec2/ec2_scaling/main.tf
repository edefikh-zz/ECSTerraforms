resource "aws_cloudwatch_metric_alarm" "ContainerInstancesShortageAlarm" {
  alarm_name          = "${var.app_name}_${var.environment}_Shortage_Container_Instances"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SchedulableContainers"
  namespace           = "${var.cluster_name}"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  period                    = "${var.ec2_scale_up_period}"
  statistic                 = "Minimum"                                       # special rule because we scale on reservations and not utilization
  threshold                 = "${var.container_shortage_threshold}"
  alarm_description         = "Cluster is running out of container instances"
  insufficient_data_actions = []
  alarm_actions             = ["${aws_autoscaling_policy.scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ContainerInstancesExcessAlarm" {
  alarm_name          = "${var.app_name}_${var.environment}_Excess_Container_Instaсnces"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SchedulableContainers"
  namespace           = "${var.cluster_name}"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  period                    = "${var.ec2_scale_down_period}"
  statistic                 = "Maximum"                                    # special rule because we scale on reservations and not utilization
  threshold                 = "${var.container_excess_threshold}"
  alarm_description         = "Cluster is wasting container instances"
  insufficient_data_actions = []
  alarm_actions             = ["${aws_autoscaling_policy.scale_down.arn}"]
}

resource "aws_cloudwatch_event_rule" "cloudwatch-cron" {
  name                = "${var.app_name}_${var.environment}_SchedulableContainersRule_cron"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda-target-cron" {
  rule = "${aws_cloudwatch_event_rule.cloudwatch-cron.name}"
  arn  = "${aws_lambda_function.ec2_scaling_lambda.arn}"
}
