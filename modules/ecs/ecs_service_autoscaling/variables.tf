variable "app_name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "cluster_name" {
  default = ""
}

variable "ecs_asg_iam_role" {
  default = ""
}

variable "ecs_task_desired_count" {
  default = ""
}

variable "ecs_service_desired_count" {
  default = ""
}

variable "ecs_task_max_count" {
  default = ""
}

variable "ecs_task_min_count" {
  default = ""
}

variable "ecs_scaling_metric_name" {
  default = ""
}

variable "ecs_high_threshold" {
  default = ""
}

variable "ecs_low_threshold" {
  default = ""
}

variable "ecs_period_increase" {
  default = ""
}

variable "ecs_period_decrease" {
  default = ""
}
