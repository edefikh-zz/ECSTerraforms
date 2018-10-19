###
# Credentials
###
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "default"
}

##
# Backend configuration
##
terraform {
  backend "s3" {
    bucket  = ""
    key     = "prod-terraform.tfstate"
    region  = "us-east-1"
    profile = "default"
  }
}

data "aws_caller_identity" "current" {
  provider = "aws"
}

###

module "cluster" {
  source = "../../modules/ecs/cluster"

  app_name    = "${var.app_name}"
  environment = "${var.environment}"
}

module "repository" {
  source = "../../modules/ecs/repository"

  app_name         = "${var.app_name}"
  environment      = "${var.environment}"
  aws_region       = "${var.aws_region}"
  account_id       = "${data.aws_caller_identity.current.account_id}"
  image_name       = "${var.dockerhub_image_name}"
  s3_path_to_image = "${var.s3_path_to_image}"
}

module "task" {
  source = "../../modules/ecs/tasks/task"

  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  container_max_cpu    = "${var.container_max_cpu}"
  container_max_memory = "${var.container_max_memory}"
  aws_region           = "${var.aws_region}"
  application_port     = "${var.application_port}"
  mount_points         = "${var.mount_points}"
  image                = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}-${var.environment}:latest"
  image_name           = "${var.app_name}-${var.environment}"
}

module "services" {
  source                    = "../../modules/ecs/service"
  app_name                  = "${var.app_name}"
  environment               = "${var.environment}"
  cluster_id                = "${module.cluster.ecs_cluster_id}"
  task_definition_arn       = "${module.task.ecs_task_arn}"
  iam_role_arn              = "${module.iam.aws_iam_role_service_arn}"
  ecs_task_desired_count    = "${var.ecs_task_desired_count}"
  alb_target_group_arn      = "${module.load_balancer.alb_target_group_arn}"
  application_port          = "${var.application_port}"
  ecs_service_desired_count = "${var.ecs_service_desired_count}"

  cluster_name            = "${module.cluster.ecs_cluster_name}"
  ecs_asg_iam_role        = "${module.iam.aws_iam_role_service_arn}"
  ecs_task_max_count      = "${var.ecs_task_max_count}"
  ecs_task_min_count      = "${var.ecs_task_min_count}"
  ecs_scaling_metric_name = "${var.ecs_scaling_metric_name}"
  ecs_high_threshold      = "${var.ecs_high_threshold}"
  ecs_low_threshold       = "${var.ecs_low_threshold}"
  ecs_period_increase     = "${var.ecs_period_increase}"
  ecs_period_decrease     = "${var.ecs_period_decrease}"
}

###

module "iam" {
  source = "../../modules/iam"

  app_name              = "${var.app_name}"
  environment           = "${var.environment}"
  aws_region            = "${var.aws_region}"
  s3_for_hostname_file  = "${var.s3_for_hostname_file}"
  iam_users_for_ec2_ssh = ["${var.iam_users_for_ec2_ssh}"]
  account_id            = "${data.aws_caller_identity.current.account_id}"
}

###

module "ec2_security_group" {
  source = "../../modules/ec2/security_groups"

  app_name     = "${var.app_name}"
  environment  = "${var.environment}"
  vpc_id       = "${var.vpc_id}"
  vpc_cidr     = "${var.vpc_cidr}"
  CIDR_for_ssh = "${var.CIDR_for_ssh}"
}

module "alb_security_group" {
  source = "../../modules/ec2/ecs_application_load_balancer/security_groups/"

  app_name           = "${var.app_name}"
  environment        = "${var.environment}"
  vpc_id             = "${var.vpc_id}"
  ec2_security_group = "${module.ec2_security_group.ec2_security_group_id}"
}

###

module "load_balancer" {
  source = "../../modules/ec2/ecs_application_load_balancer"

  app_name              = "${var.app_name}"
  environment           = "${var.environment}"
  vpc_id                = "${var.vpc_id}"
  public_subnets        = "${var.public_subnets}"
  alb_security_group_id = "${module.alb_security_group.alb_security_group_id}"
  application_port      = "${var.application_port}"
  ssl_certificate       = "${lookup(var.arn_certificate, var.ssl_certificate, "")}"
}

###

module "launch_configuration" {
  source = "../../modules/ec2/ec2_launch_configuration"

  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  image_id             = "${lookup(var.images, var.aws_region, "")}"
  instance_type        = "${var.ec2_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${module.iam.aws_iam_instance_profile_name}"
  ec2_security_groups  = "${module.ec2_security_group.ec2_security_group_id}"
  cluster              = "${module.cluster.ecs_cluster_name}"
  aws_region           = "${var.aws_region}"
  s3_hostnames         = "${var.s3_hostnames}"
}

module "autoscaling_group" {
  source = "../../modules/ec2/ec2_autoscaling_group"

  app_name                      = "${var.app_name}"
  environment                   = "${var.environment}"
  aws_launch_configuration_name = "${module.launch_configuration.aws_launch_configuration_name}"
  public_subnets                = "${var.public_subnets}"
  asg_ec2_max                   = "${var.asg_ec2_max}"
  asg_ec2_min                   = "${var.asg_ec2_min}"
  asg_ec2_desired               = "${var.asg_ec2_desired}"
  alb_target_group_arn          = "${module.load_balancer.alb_target_group_arn}"
}

module "ec2_scaling" {
  source = "../../modules/ec2/ec2_scaling"

  app_name    = "${var.app_name}"
  environment = "${var.environment}"

  container_excess_threshold   = "${var.container_excess_threshold}"
  container_shortage_threshold = "${var.container_shortage_threshold}"
  ec2_scale_up_period          = "${var.ec2_scale_up_period}"
  ec2_scale_down_period        = "${var.ec2_scale_down_period}"
  cluster_name                 = "${module.cluster.ecs_cluster_name}"
  container_max_cpu            = "${var.container_max_cpu}"
  container_max_memory         = "${var.container_max_memory}"
  lambda_iamrole               = "${module.iam.lambda_iamrole}"
  autoscaling_group_name       = "${module.autoscaling_group.autoscaling_group_name}"
}

###

module "rds" {
  source = "../../modules/rds"

  app_name               = "${var.app_name}"
  environment            = "${var.environment}"
  db_name                = "${replace((var.db_name == "" ?  "${var.app_name}_${var.environment}_master" : var.db_name), "-", "_")}"
  db_username            = "${replace(replace((var.db_username == "" ? "${var.app_name}_${var.environment}_user" : var.db_username), "-", "_"), "/(.{0,16})(.*)/", "$1")}"
  db_password            = "${var.db_password}"
  db_instance_name       = "${replace((var.db_instance_name == "" ? "${var.app_name}-${var.environment}-master" : var.db_instance_name), "_", "-")}"
  db_instance_type       = "${var.db_instance_type}"
  vpc_security_group_ids = "${module.rds_security_group.aws_security_group_id}"
  private_subnets        = "${var.private_subnets}"
  db_engine              = "${var.db_engine}"
  db_storage             = "${var.db_storage}"
}

module "rds_security_group" {
  source = "../../modules/rds/security_groups"

  app_name                 = "${var.app_name}"
  environment              = "${var.environment}"
  vpc_id                   = "${var.vpc_id}"
  source_security_group_id = "${module.ec2_security_group.ec2_security_group_id}"
  db_engine                = "${var.db_engine}"
}
