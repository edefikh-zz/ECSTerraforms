variable "bucket" {
  description = "S3 bucket for terraform versioning"
  default     = ""
}

variable "key" {
  description = "path at your backet"
  default     = ""
}

variable "shared_credentials_file" {
  description = "path at your aws configurations file"
  default     = "~/.aws/credentials"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "app_name" {
  description = "application name"
  default     = "testapp"
}

variable "environment" {
  description = "environment"
  default     = "test"
}

## Task definition

variable "container_max_cpu" {
  description = "The maximum number of cpu reservation per container that you plan to run on this cluster."
  default     = "128"
}

variable "container_max_memory" {
  description = "The maximum number of memory reservation (in MB)  per container that you plan to run on this cluster."
  default     = "256"
}

variable "application_port" {
  description = "Application Port inside continer."
  default     = "80"
}

variable "mount_points" {
  default     = []
  description = "a list of maps"
}

### 

variable "s3_for_hostname_file" {
  description = "S3's bucket name, which stores hostname file"
  default     = ""
}

variable "vpc_id" {
  description = "VPC for your stack placement"
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR of yours VPC"
  default     = ""
}

variable "CIDR_for_ssh" {
  description = "CIDRs which allowed ssh access to EC2. Should be the list separated by commas."
  default     = ""
}

### LB

variable "arn_certificate" {
  description = "Wildcard SSL certificate's ARN  for Load Balancer."
  type        = "map"

  default = {
    ""                    = ""
    "site1.com"         = "arn:aws:acm:us-east-1:..."
    "site2.com"         = "arn:aws:acm:us-east-1:..."
    "site3.com"         = "arn:aws:acm:us-east-1:..."
  }
}

variable "ssl_certificate" {
  description = "Wildcard SSL certificate for Load Balancer. Allowed values: site1.com, site2.com or site3.com. If don't need it - left empty"
  default     = "site1.com"
}

variable "public_subnets" {
  description = "Your VPC`s public subnets IDs. Should be the list separated by commas"
  default     = ""
}

variable "private_subnets" {
  description = "Your VPC`s private subnets IDs. Should be the list separated by commas"
  default     = ""
}

### Service

variable "ecs_task_desired_count" {
  description = "The desired capacity of tasks at ECS service"
  default     = "2"
}

variable "ecs_service_desired_count" {
  description = "The desired capacity of services at the Cluster"
  default     = "2"
}

variable "ecs_task_max_count" {
  description = "Max amount of task per ecs service"
  default     = "4"
}

variable "ecs_task_min_count" {
  description = "Min amount of task per ecs service"
  default     = "2"
}

variable "ecs_scaling_metric_name" {
  description = "Scaling metric name for ECS task scaling. Allowed values are CPUUtilization, CPUReservation, MemoryUtilization, MemoryReservation. Docs can be found here: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ecs-metricscollected.html"
  default     = "MemoryUtilization"
}

variable "ecs_high_threshold" {
  description = "The value in percent against which ECS starts additional task. Before set, plese read the doc at ecs_scaling_metric_name description"
  default     = "70"
}

variable "ecs_low_threshold" {
  description = "The value in percent below  which ECS removes additional task. Before set, plese read the doc at ecs_scaling_metric_name description"
  default     = "30"
}

variable "ecs_period_increase" {
  description = "The time in seconds over which the specified statistic is applied for adding extra task."
  default     = "60"
}

variable "ecs_period_decrease" {
  description = "The time in seconds over which the specified statistic is applied for removing extra task."
  default     = "60"
}

### Launch_congiguration

variable "images" {
  type        = "map"
  description = "ECS optimized AMI. Full list here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"

  default = {
    "us-east-1" = "ami-cad827b7"
    "us-east-2" = "ami-ef64528a"
    "us-west-1" = "ami-29b8b249"
    "us-west-2" = "ami-baa236c2"
  }
}

variable "ec2_instance_type" {
  description = "The desired type of EC2 instances at the Cluster"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair for EC2 instances"
  default     = ""
}

variable "s3_hostnames" {
  description = "Bucket`s name where info about free/buse hostnames stored"
  default     = ""
}

variable "asg_ec2_min" {
  description = "Minimal amount of ec2 instances at ECS cluster"
  default     = "2"
}

variable "asg_ec2_max" {
  description = "Max amount of ec2 instances at ECS cluster"
  default     = "4"
}

variable "asg_ec2_desired" {
  description = "Desired amount of ec2 instances at ECS cluster"
  default     = "2"
}

variable "iam_users_for_ec2_ssh" {
  type = "list"

  description = <<EOF
                  List of IAM users which will have access to the EC2. This users should have uploaded public keys. 
                  Variable has type list. Check syntax here https://www.terraform.io/docs/configuration/variables.html
                  EOF

  default = []
}

### RDS

variable "db_engine" {
  description = "Database`s engine. Allowed values are postgres and mysql"
  default     = ""
}

variable "db_storage" {
  description = "DB's storage size"
  default     = ""
}

variable "db_name" {
  description = "Database`s name"
  default     = ""
}

variable "db_username" {
  description = "Database`s username"
  default     = ""
}

variable "db_instance_name" {
  description = "RDS instance`s name"
  default     = ""
}

variable "db_instance_type" {
  description = "RDS type. Allowed values are db.t1.micro, db.m1.small, db.m1.medium, db.m1.large,db.t2.micro, db.t2.small, db.t2.medium, db.t2.large etc"
  default     = "db.t2.micro"
}

variable "db_password" {
  description = "Database`s password"
  default     = ""
}

### ec2 scaling

variable "container_shortage_threshold" {
  description = "Scale up if free cluster capacity <= containers (based on ContainerMaxCPU and ContainerMaxMemory settings)"
  default     = "0"
}

variable "container_excess_threshold" {
  description = "Scale down if free cluster capacity >= containers (based on ContainerMaxCPU and ContainerMaxMemory settings)"
  default     = "2"
}

variable "ec2_scale_up_period" {
  description = "Pause between ec2 scale up actions"
  default     = "300"
}

variable "ec2_scale_down_period" {
  description = "Pause between ec2 scale down actions"
  default     = "600"
}

###

variable "s3_path_to_image" {
  description = <<EOF
                  Path to docker image at S3 bucket like: Bucketname/Folder/.../Image_Name. Dont need it, if use dockerhub_image_name. 
                  If left dockerhub_image_name and s3_path_to_image empty, empty repository will be created.
                  EOF

  default = ""
}

variable "dockerhub_image_name" {
  description = "Specify image name at DockerHub (nginx, node etc). Leave this field empty if specified s3_path_to_image"
  default     = ""
}
