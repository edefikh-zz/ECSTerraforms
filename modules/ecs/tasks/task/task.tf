data "aws_caller_identity" "current" {}

resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.app_name}-${var.environment}"
  container_definitions = "${data.template_file._final.rendered}"
}

output "ecs_task_arn" {
  value = "${aws_ecs_task_definition.ecs_task.arn}"
}
