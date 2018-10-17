terraform {
  backend "s3" {
    bucket = "bscc-terraform-state1"
    key = "network/qa-terraform.tfstate"
    region = "us-east-1"
    profile = "default"

  }
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.environment}-${var.app}-vpc"
    }
}
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

/*
  Public Subnets
*/

resource "aws_subnet" "1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "${var.environment}-${var.app}-Public Subnet1"
    }
}

resource "aws_route_table" "1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.environment}-${var.app}-Public Subnet1"
    }
}

resource "aws_route_table_association" "1a-public" {
    subnet_id = "${aws_subnet.1a-public.id}"
    route_table_id = "${aws_route_table.1a-public.id}"
}


resource "aws_subnet" "1e-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "us-east-1e"

    tags {
        Name = "${var.environment}-${var.app}-Public Subnet2"
    }
}

resource "aws_route_table" "1e-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.environment}-${var.app}-Public Subnet2"
    }
}

resource "aws_route_table_association" "1e-public" {
    subnet_id = "${aws_subnet.1e-public.id}"
    route_table_id = "${aws_route_table.1e-public.id}"
}
