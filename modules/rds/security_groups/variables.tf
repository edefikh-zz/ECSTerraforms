variable "app_name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "source_security_group_id" {
  default = ""
}

variable "db_engine" {
  default = ""
}

variable "db_port" {
  type        = "map"
  description = "DB port for security group"

  default = {
    "postgres" = "5432"
    "mysql"    = "3306"
  }
}
