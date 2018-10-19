resource "aws_iam_role" "ecs_scale_role" {
  name               = "${var.app_name}-${var.environment}-ecs-scale-iam"
  description        = "Main IAM Role for ECS service role"
  assume_role_policy = "${file( "${path.module}/policies/assumerole_ecs_as.json" )}"
}

data "template_file" "ecs_scale_policy" {
  template = "${file( "${path.module}/policies/ecs_scale_policy.json" )}"
}

resource "aws_iam_role_policy" "ecs_scale_policy" {
  name   = "${var.app_name}-${var.environment}-ecs_scale_policy"
  role   = "${aws_iam_role.ecs_scale_role.id}"
  policy = "${data.template_file.ecs_scale_policy.rendered}"
}
