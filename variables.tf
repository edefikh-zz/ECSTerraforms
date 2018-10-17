
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "bucket" {
    description = "S3 bucket for terraform versioning"
    default = ""
}
variable "key" {
    description = "path at your backet"
    default = ""
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "app" {
    description = "application name"
    default = "app"
}

variable "environment" {
    description = "environment"
    default = "qa"
}

variable "ami_id" {
    description = "Mapping of Amzon's AMIs."
    default = {
        eu-west-2 = "ami-ee7d618a"
        eu-west-1 = "ami-d65dfbaf"
        ap-northeast-2 = "ami-70d0741e"
        ap-northeast-1 = "ami-95903df3"
        ca-central-1 = "ami-fc5fe798"
        ap-southeast-1 = "ami-c8c98bab"
        ap-southeast-2 = "ami-e3b75981"
        eu-central-1 = "ami-ebfb7e84"
        us-east-1 = "ami-20ff515a"
        us-east-2 = "ami-b0527dd5"
        us-west-1 ="ami-b388b4d3"
        us-west-2 ="ami-3702ca4f"
    }
}

variable "number_of_instances" {
    description = "desired count of EC2"
    default = "2"
}

variable "instance_type" {
    description = "EC2 instance type"
    default = "t2.micro"
}

variable "user_data" {
    description = "user data file for your instances"
    default = "userdata.txt"
}

variable "availability_zones" {
    description = "Mapping of Amzon's AMIs."
    default = {
        eu-west-2 = "eu-west-2a,eu-west-2b"
        eu-west-1 = "eu-west-1a,eu-west-1b,eu-west-1c"
        ap-northeast-2 = "ap-northeast-2a,ap-northeast-2c"
        ap-northeast-1 = "ap-northeast-1a,ap-northeast-1c"
        ca-central-1 = "ca-central-1a,ca-central-1b"
        ap-southeast-1 = "ap-southeast-1a,ap-southeast-1b"
        ap-southeast-2 = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
        eu-central-1 = "eu-central-1a,eu-central-1b"
        us-east-1 = "us-east-1a,us-east-1b,us-east-1c,us-east-1e"
        us-east-2 = "us-east-2a,us-east-2b,us-east-2c"
        us-west-1 ="us-west-1a,us-west-1b"
        us-west-2 ="us-west-2a,us-west-2b,us-west-2c"
    }
}

variable "health_check_type" {
    description = "EC2's health_check_type"
    default = "EC2"
}

variable "health_check_grace_period" {
    description = "health_check_grace_period"
    default = "300"
}

variable "asg_number_of_instances" {
    description = "number of instances at scaling group"
    default = "2"
}

variable "asg_minimum_number_of_instances" {
    description = "minimum number of instances at scaling group"
    default = "2"
}

//

variable "backend_port" {
    description = "backend_port"
    default = "80"
}

variable "backend_protocol" {
    description = "backend_protocol"
    default = "http"
}

variable "health_check_target" {
    description = "health_check_target"
    default = "HTTP:80/"
}

variable "elb_is_internal" {
  description = "Determines if the ELB is internal or not"
  default = false
}

//

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "public_subnet2_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet1_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}

variable "private_subnet2_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.3.0/24"
}

variable "tags" {
  default = {
    created_by = "terraform"
 }
}
