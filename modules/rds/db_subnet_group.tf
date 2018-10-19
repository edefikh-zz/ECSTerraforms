resource "aws_db_subnet_group" "db_subnet_group" {
  name_prefix = "${var.app_name}-${var.environment}-sub-grp"
  description = "Database subnet group for ${var.app_name}-${var.environment}}"
  subnet_ids  = ["${split(", ", (var.private_subnets))}"]
}
