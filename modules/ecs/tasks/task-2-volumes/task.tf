data "aws_caller_identity" "current" {}

resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.app_name}-${var.environment}"
  container_definitions = "${data.template_file._final.rendered}"

  volume {
    name      = "${lookup(var.mount_points[0], "source_volume", "")}"
    host_path = "${lookup(var.mount_points[0], "host_path", "")}"
  }

  volume {
    name      = "${lookup(var.mount_points[1], "source_volume", "")}"
    host_path = "${lookup(var.mount_points[1], "host_path", "")}"
  }
}

output "ecs_task_arn" {
  value = "${aws_ecs_task_definition.ecs_task.arn}"
}
