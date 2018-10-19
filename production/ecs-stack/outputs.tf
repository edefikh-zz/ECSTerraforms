output "RDS_instance_name" {
  value = "${module.rds.db_instance_name}"
}

output "RDS_db_name" {
  value = "${module.rds.db_name}"
}

output "RDS_username" {
  value = "${module.rds.db_username}"
}

output "alb_dns_name" {
  description = "The DNS name of ALB"
  value       = "${module.load_balancer.alb_dns_name}"
}
