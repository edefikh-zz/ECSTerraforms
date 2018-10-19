resource "aws_iam_role" "service" {
  name               = "${var.app_name}-${var.environment}-iam-service"
  description        = "IAM Role for ECS service"
  assume_role_policy = "${file( "${path.module}/policies/assumerole_ecs.json" )}"
}

###

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
