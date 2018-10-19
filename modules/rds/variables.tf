variable "app_name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "db_name" {
  default = ""
}

variable "db_username" {
  default = ""
}

variable "db_password" {}

variable "db_instance_name" {
  default = ""
}

variable "db_instance_type" {
  default = ""
}

variable "vpc_security_group_ids" {
  default = ""
}

variable "parameter_group_name" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "db_engine" {
  default = ""
}

variable "db_storage" {
  default = ""
}

variable "db_version" {
  type        = "map"
  description = "DB engine's version"

  default = {
    "postgres" = "9.6.6"
    "mysql"    = "5.6.39"
  }
}

variable "db_port" {
  type        = "map"
  description = "DB port for security group"

  default = {
    "postgres" = "5432"
    "mysql"    = "3306"
  }
}

variable "db_license" {
  description = "license of db engine"

  default = {
    "postgres" = "postgresql-license"
    "mysql"    = ""
  }
}
