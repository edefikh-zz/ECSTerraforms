provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
}

terraform {
  backend "s3" {
    bucket = "${var.bucket}"
    key = "${var.key}"
    region = "us-east-1"
    profile = "default"

  }
}
