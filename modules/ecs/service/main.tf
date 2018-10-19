resource "aws_ecs_service" "primary" {
  count           = "${var.ecs_service_desired_count}"
  name            = "${var.app_name}-${var.environment}-${count.index + 1}"
  cluster         = "${var.cluster_id}"
  task_definition = "${var.task_definition_arn}"
  iam_role        = "${var.iam_role_arn}"
  desired_count   = "${var.ecs_task_desired_count}"

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name   = "${var.app_name}-${var.environment}"
    container_port   = "${var.application_port}"
  }
}
