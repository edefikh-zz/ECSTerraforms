# Mount volumes to ECS containers

Unfortunately there is no easy way to provide dynamic quantity of volumes at Terraform. So if you need to use volumes, should do:

### 1. Add to terraform.tfvars parameter mount_points that describes all requirements for volume creation.

At showed below example, we create two volumes and mounts /tmp and /var to container:

```tf
 mount_points = [
  {
    "source_volume" = "tmp"
    "container_path" = "/tmp"
    "read_only"     = "false"
    "host_path"    = "/tmp"
  },
  {
    "source_volume" = "var"
    "container_path" = "/var"
    "read_only"     = "false"
    "host_path"    = "/var"
  },
]
```

2. Change path to task module at main.tf. We have 3 options - 
- task without volumes (task) 
- task with 1 volume (task-1-volume) 
- task with 2 volumes (task-2-volumes) 

```tf 
module "task" {
  source = "../../modules/ecs/tasks/task-2-volumes"
```
