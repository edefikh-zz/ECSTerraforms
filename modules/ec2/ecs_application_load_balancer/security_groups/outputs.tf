output "alb_security_group_id" {
  description = "The ALBs security group ID"
  value       = "${aws_security_group.alb.id}"
}
