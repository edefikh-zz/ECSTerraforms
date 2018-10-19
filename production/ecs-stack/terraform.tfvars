aws_region = "us-east-1"
environment = "test"
app_name = "app"

bucket = "bucket-namr"
key = "foldername/filename.tfstate"

### Network's & Security  settings

vpc_id = ""
vpc_cidr = ""
public_subnets = "subnet1-id, subnet2-id"
CIDR_for_ssh = ""
iam_users_for_ec2_ssh = ["", ""]
ssl_certificate = ""
key_name = ""

### ECS basic and autoscaling settings

dockerhub_image_name = "nginx"
s3_path_to_image = ""
container_max_cpu = "512"
container_max_memory = "1024"
application_port = "80"
ecs_task_min_count = "2"
ecs_task_max_count = "4"
ecs_task_desired_count = "2"
ecs_service_desired_count = "2"
ecs_scaling_metric_name   = "MemoryUtilization"
ecs_high_threshold        = "70"
ecs_low_threshold         = "30"
ecs_period_increase       = "60"
ecs_period_decrease       = "300"

### EC2 settings

ec2_instance_type = "t2.micro"
asg_ec2_max    = "4"
asg_ec2_min    = "2"
asg_ec2_desired = "2"
ec2_scale_up_period = "300"
ec2_scale_down_period = "600"
container_shortage_threshold = "0"
container_excess_threshold = "3"

### RDS settings

db_engine        = "mysql"
db_name          = "" 
db_username      = ""
db_password      = "password"
db_instance_name = ""
db_instance_type = "db.t2.micro"
db_storage       = "20"



