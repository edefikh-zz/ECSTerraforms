# ECSTerraforms
Basic Terraforms modules to setup VPC on AWS with ECS cluster

to install:
1) clone the repo
2) cd terraform/production/ecs-stack, edit variables.tf and terraform.tfvars and then terraform init, terraform apply

Template creates ready-to-serve ECS cluster for one-image application, with all required services:
  - ECS task,service and cluster.
  - Autoscaling group with custom user-data at Launch configuration
  - Application Load Balancer.
  - Configured log and metrics agents.
  - RDS instance.
  - Required security groups and IAM policies.

Main idea is that cluster could be created with minimum editing of existing modules.
You only need to set all required variables at 'terraform.tfvars' file and run 'terraform apply' command.
If some variables raise questions, you could find short description of each one at 'variables.tf' file.

Terraform template's structure is split into two parts:
- modules located at terraform/modules
- configuration, located at terraform/ecs-stack/production

ECS cluster
  Template creates ECR for cluster needs. You could use image from the Dockerhub/get custom image from a S3 bucket/use existing ECR repo. Anyway don't forget to set application port.
You could customize cluster size. By default it creates one cluster with two services. Two task per service. Uses taccordingly.wo EC2 instances.

Security groups
  Each EC2 instance has rules, which allow to receive traffic from ALB, ping each other (need to get instance tags), and SSH access for some predefined CIDRs (var.CIDR_for_ssh)

Also EC2 instances has access to cluster's RDS.
  ALB SG allows to get traffic by HTTP, and if SSL cert is defined, also allows to receive HTTPS.

Autoscaling group
  ECS cluster placed at EC2 instances of desired type.

Autoscale group capacity by default - 2 EC2 instances, could be increased by variable 'asg_ec2_desired'.
Min and max cluster's capacity also could be set by 'asg_ec2_min' and 'asg_ec2_max' variables.

EC2 instances scale up and down according Lambda's commands. It's better described here: https://garbe.io/blog/2017/04/12/a-better-solution-to-ecs-autoscaling/
 Special bash script which runs at UserData provides unique hostnames and name tags for each EC2. Those hostnames has {var.app_name}-{var.environment}-number_in_cluster structure, for example
 app-production-001, nginx-stage-004 etc. This script require S3 bucket to store file with all used hostnames.
 Also each instance has configured SumoLogic and NewRelic agents. Their license keys should be set accordingly. You could check Sumologic config at UserData file.
 Each instance could be accessed by IAM Users SSHkeys. To use this feature you should set required IAM users list at variable 'iam_users_for_ec2_ssh'. This users should have uploaded public keys.

RDS instance
  Template creates RDS instance of desired type at private VPC. You could choose to use PostgreSQL or MySQL.
Also provide checks of username/DB or instance names. For example DB name couldn't have "-", so template will replace it with "_"
By default RDS SG allows only cluster's EC2 to have access to RDS.
