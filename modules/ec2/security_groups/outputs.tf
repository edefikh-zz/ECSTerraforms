output "ec2_security_group_id" {
  description = "The ec2s security group ID"
  value       = "${aws_security_group.ec2.id}"
}
