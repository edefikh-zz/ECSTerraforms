resource "aws_cloudwatch_metric_alarm" "utilization_high_alarm" {
  count               = "${var.ecs_service_desired_count}"
  alarm_name          = "${format("%s", "${var.app_name}-${var.environment}-${count.index + 1}-utilization-high")}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.ecs_scaling_metric_name}"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_period_increase}"
  statistic           = "Average"
  threshold           = "${var.ecs_high_threshold}"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${format("%s", "${var.app_name}-${var.environment}-${count.index + 1}")}"
  }

  alarm_description = "Scale up if the utilization  is above N% for N duration"
  alarm_actions     = ["${element(aws_appautoscaling_policy.up.*.arn, count.index)}"]
}

resource "aws_cloudwatch_metric_alarm" "utilization_low_alarm" {
  count               = "${var.ecs_service_desired_count}"
  alarm_name          = "${format("%s", "${var.app_name}-${var.environment}-${count.index + 1}-utilization-low")}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.ecs_scaling_metric_name}"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_period_decrease}"
  statistic           = "Average"
  threshold           = "${var.ecs_low_threshold}"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${format("%s", "${var.app_name}-${var.environment}-${count.index + 1}")}"
  }

  alarm_description = "Scale down if the utilization  is below N% for N duration"
  alarm_actions     = ["${element(aws_appautoscaling_policy.down.*.arn, count.index)}"]
}
