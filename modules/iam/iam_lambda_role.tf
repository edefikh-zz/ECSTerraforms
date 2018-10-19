resource "aws_iam_role" "lambda" {
  name               = "${var.app_name}-${var.environment}-lambda"
  description        = "IAM Role for Lambda's  cloudwatch script"
  assume_role_policy = "${file( "${path.module}/policies/assumerole_lambda.json" )}"
}

resource "aws_iam_role_policy" "lambda" {
  role   = "${aws_iam_role.lambda.id}"
  name   = "${var.app_name}-${var.environment}-lambda"
  policy = "${file( "${path.module}/policies/lambda.json" )}"
}

data "template_file" "lambda" {
  template = "${file( "${path.module}/policies/lambda.json" )}"

  vars {
    app_name    = "${var.app_name}"
    environment = "${var.environment}"
    aws_region  = "${var.aws_region}"
    accountid   = "${data.aws_caller_identity.current.account_id}"
  }
}
