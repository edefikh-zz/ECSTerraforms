data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function/"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "ec2_scaling_lambda" {
  filename         = "${data.archive_file.lambda_code.output_path}"
  function_name    = "${var.app_name}-${var.environment}"
  role             = "${var.lambda_iamrole}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_code.output_base64sha256}"
  runtime          = "nodejs6.10"
  timeout          = "60"

  environment {
    variables = {
      cluster_name         = "${var.app_name}-${var.environment}"
      container_max_cpu    = "${var.container_max_cpu}"
      container_max_memory = "${var.container_max_memory}"
    }
  }
}
