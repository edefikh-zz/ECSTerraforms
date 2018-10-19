resource "aws_appautoscaling_target" "ecs_target" {
  count              = "${var.ecs_service_desired_count}"
  max_capacity       = "${var.ecs_task_max_count}"
  min_capacity       = "${var.ecs_task_min_count}"
  resource_id        = "${format("%s", "service/${var.cluster_name}/${var.app_name}-${var.environment}-${count.index + 1}")}"
  role_arn           = "${var.ecs_asg_iam_role}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = ["aws_ecs_service.primary"]
}

resource "aws_appautoscaling_policy" "down" {
  count              = "${var.ecs_service_desired_count}"
  name               = "${format("%s", "${var.app_name}-${var.environment}-scale-down-${count.index + 1}")}"
  resource_id        = "${format("%s", "service/${var.cluster_name}/${var.app_name}-${var.environment}-${count.index + 1}")}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "120"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "up" {
  count              = "${var.ecs_service_desired_count}"
  name               = "${format("%s", "${var.app_name}-${var.environment}-scale-up-${count.index + 1}")}"
  service_namespace  = "ecs"
  resource_id        = "${format("%s", "service/${var.cluster_name}/${var.app_name}-${var.environment}-${count.index + 1}")}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "60"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}
