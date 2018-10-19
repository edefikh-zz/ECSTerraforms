resource "aws_ecr_repository" "docker-image-repository" {
  count = "${var.image_name != "" ? 1 : 0}"
  name  = "${var.app_name}-${var.environment}"

  provisioner "local-exec" {
    command = <<EOF
    docker pull ${var.image_name}
    aws ecr get-login --no-include-email --region ${var.aws_region} | bash 
    docker tag ${var.image_name} ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.docker-image-repository.name}:latest  
    docker push  ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.docker-image-repository.name}:latest
  EOF
  }
}

resource "aws_ecr_repository" "s3-image-repository" {
  count = "${var.s3_path_to_image != "" ? 1 : 0}"
  name  = "${var.app_name}-${var.environment}"

  provisioner "local-exec" {
    command = <<EOF
    aws s3 cp s3://${var.s3_path_to_image} ${path.module}/image.tar
    aws ecr get-login --no-include-email --region ${var.aws_region} | bash
    docker tag ${var.image_name} ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.s3-image-repository.name}:latest
    docker push  ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.s3-image-repository.name}:latest
    rm ${path.module}/image.tar
  EOF
  }
}

resource "aws_ecr_repository" "empty-repository" {
  count = "${(var.s3_path_to_image == "" ? 1 : 0) * (var.image_name == "" ? 1 : 0)}"
  name  = "${var.app_name}-${var.environment}"
}
