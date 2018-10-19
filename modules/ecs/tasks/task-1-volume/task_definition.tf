data "template_file" "_port_mapping" {
  template = <<JSON
{$${join(",",
  compact(
    list(
    hostPort == "" ? "" : "$${jsonencode("hostPort")}: $${hostPort}",
    "$${jsonencode("containerPort")}: $${containerPort}",
    protocol == "" ? "" : "$${jsonencode("protocol")}: $${jsonencode(protocol)}"

    )
  )
)}}
JSON

  vars {
    hostPort = "0"

    containerPort = "${var.application_port}"
    protocol      = "tcp"
  }
}

data "template_file" "_port_mappings" {
  template = <<JSON
"portMappings": [$${ports}]
JSON

  vars {
    ports = "${join(",",data.template_file._port_mapping.*.rendered)}"
  }
}

data "template_file" "_mount_keys" {
  count = "${length(var.mount_points)}"

  template = <<JSON
{$${join(",",
  compact(
    list(
      "$${jsonencode("sourceVolume")}: $${jsonencode(sourceVolume)}",
      "$${jsonencode("containerPath")}: $${jsonencode(containerPath)}",
      read_only == "" ? "" : "$${jsonencode("readOnly")} : $${read_only == 1 ? true : false}"
    )
  )
)}}
JSON

  vars {
    sourceVolume  = "${lookup(var.mount_points[count.index], "source_volume")}"
    containerPath = "${lookup(var.mount_points[count.index], "container_path")}"
    read_only     = "${lookup(var.mount_points[count.index], "read_only", "")}"
  }
}

data "template_file" "_mount_list" {
  template = <<JSON
"mountPoints": [$${mounts}]
JSON

  vars {
    mounts = "${join(",",data.template_file._mount_keys.*.rendered)}"
  }
}

data "template_file" "_final" {
  template = <<JSON
  [{
    $${val}
  }]
JSON

  vars {
    val = "${join(",",
      compact(
        list(
          "${jsonencode("essential")}: true",
          "${jsonencode("name")}: ${jsonencode(var.image_name)}",
          "${jsonencode("image")}: ${jsonencode(var.image)}",
          "${jsonencode("cpu")}: ${var.container_max_cpu}",
          "${jsonencode("memory")}: ${var.container_max_memory}",
          "${data.template_file._port_mappings.rendered}",
          "${length(var.mount_points) > 0 ? data.template_file._mount_list.rendered : "" }",
        )
        )
      )}"
  }
}
