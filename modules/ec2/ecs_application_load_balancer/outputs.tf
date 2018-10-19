output "alb_dns_name" {
  description = "The DNS name of the ALB presumably to be used with a friendlier CNAME."
  value       = "${aws_alb.main.dns_name}"
}

output "alb_id" {
  value = "${aws_alb.main.id}"
}

output "alb_target_group_arn" {
  value = "${aws_alb_target_group.target_group.arn}"
}
