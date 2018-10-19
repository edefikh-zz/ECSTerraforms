resource "aws_db_instance" "rds_instance" {
  identifier        = "${var.db_instance_name}"
  engine            = "${var.db_engine}"
  instance_class    = "${var.db_instance_type}"
  allocated_storage = "${var.db_storage}"
  storage_type      = "gp2"
  engine_version    = "${lookup(var.db_version, var.db_engine)}"
  license_model     = "${lookup(var.db_license, var.db_engine)}"

  name     = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  port     = "${lookup(var.db_port, var.db_engine)}"

  vpc_security_group_ids     = ["${var.vpc_security_group_ids}"]
  db_subnet_group_name       = "${aws_db_subnet_group.db_subnet_group.name}"
  parameter_group_name       = "${var.parameter_group_name}"
  multi_az                   = "true"
  backup_window              = "06:53-07:23"
  backup_retention_period    = "7"
  auto_minor_version_upgrade = "true"
  skip_final_snapshot        = "true"
}
