variable "app_name" {
  default = ""
}

variable "environment" {
  default = ""
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.app_name}-${var.environment}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs-cluster.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs-cluster.name}"
}
