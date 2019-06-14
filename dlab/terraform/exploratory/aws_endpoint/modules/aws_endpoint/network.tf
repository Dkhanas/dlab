# Local vars for tags
locals {
  subnet_name = "${var.env_name}-subnet"
  sg_name     = "${var.env_name}-sg"
}


resource "aws_vpc" "vpc_create" {
  cidr_block         = var.cidr_range
  count              = var.vpc_id_existed == "" ? 1 : 0
  instance_tenancy   = "default"
}

data "aws_vpc" "data_vpc" {
  id = var.vpc_id_existed == "" ? aws_vpc.vpc_create.0.id : var.vpc_id_existed
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_create.0.id
  count  = var.vpc_id_existed == "" ? 1 : 0
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "endpoint_subnet" {
  vpc_id            = aws_vpc.vpc_create.0.id
  cidr_block        = var.cidr_range
  availability_zone = var.zone_var
  tags = {
    Name = "${local.subnet_name}"
    "${var.env_name}-Tag" = "${local.subnet_name}"
    product = "${var.product}"
    "user:tag" = "${var.env_name}:${local.subnet_name}"
  }
  count = var.vpc_id_existed == "" ? 1 : 0
}

data "aws_subnet" "data_subnet" {
  id = var.subnet_id == "" ? aws_subnet.endpoint_subnet.0.id : var.subnet_id
}

resource "aws_route" "route" {
  count                     = var.vpc_id_existed == "" ? 1 : 0
  route_table_id            = aws_vpc.vpc_create.0.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.0.id
}

resource "aws_security_group" "endpoint_sec_group" {
  name        = "endpoint_sec_group"
  vpc_id      = data.aws_vpc.data_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
  Name = "${local.sg_name}"
  product = "${var.product}"
  "user:tag" = "${var.env_name}:${local.sg_name}"
  }
}

