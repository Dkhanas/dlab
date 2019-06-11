provider "aws" {
  access_key = "${var.access_key_var}"
  secret_key = "${var.secret_key_var}"
  region = "${var.region_var}"
}

module "aws_endpoint" {
  source = "../modules/aws_endpoint"
  env_name = "${var.env_name}"
  region = "${var.region_var}"
  zone = "${var.zone_var}"
  product = "${var.product_name}"
  cidr_range = "${var.cidr_range}"
  instance_shape = "${var.instance_shape}"
  key_name_var = "${var.key_name_var}"
  ami = "${var.ami}"
  env_os = "${var.env_os}"
}