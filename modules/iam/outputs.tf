output "aws_iam_role_service_arn" {
  description = "The IAM`s service role ARN"
  value       = "${aws_iam_role.service.arn}"
}

output "aws_iam_role_main_arn" {
  description = "The IAM`s main  role ARN"
  value       = "${aws_iam_role.main.arn}"
}

output "aws_iam_instance_profile_name" {
  description = "instance profile name"
  value       = "${aws_iam_instance_profile.ec2_profile.name}"
}

output "lambda_iamrole" {
  description = "instance profile name"
  value       = "${aws_iam_role.lambda.arn}"
}
