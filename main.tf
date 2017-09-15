provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "MQB_Server" {
        ami="ami-c998b6b2"
        instance_type="t2.micro"
	key_name = "USVirginia"
	subnet_id ="${aws_subnet.mqb_subnet.id}"
}
resource "aws_security_group" "MQB_Dev_group" {
	name = "MQB_TEST"
 	vpc_id = "${aws_vpc.mqb_vpc.id}"
}
resource "aws_security_group_rule" "MQB_Sec_Group_1" {
	security_group_id = "${aws_security_group.MQB_Dev_group.id}"
	type = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
	to_port     = 22
	protocol    = "tcp"
}
resource "aws_security_group_rule" "MQB_Sec_Group_2" {
	security_group_id = "${aws_security_group.MQB_Dev_group.id}"
	type = "egress"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
	to_port     = 22
	protocol    = "all"
}
resource "aws_vpc" "mqb_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  
       tags {
	name = "mqb_vpc"
}
}
resource "aws_subnet" "mqb_subnet" {
  vpc_id = "${aws_vpc.mqb_vpc.id}"
  cidr_block = "10.0.0.0/16"
  map_public_ip_on_launch = true
      tags {
	name = "mqb_subnet"
}
}
resource "aws_internet_gateway" "mqb_internet_gateway" {
  vpc_id = "${aws_vpc.mqb_vpc.id}"
	tags {
         name = "mqb_internet"
}
}
resource "aws_route_table" "MQB_Public_route" {
   vpc_id = "${aws_vpc.mqb_vpc.id}"
   propagating_vgws = []
}
resource "aws_route" "mqb_public" {
   route_table_id = "${aws_route_table.MQB_Public_route.id}"
   destination_cidr_block = "0.0.0.0/0"
   gateway_id     = "${aws_internet_gateway.mqb_internet_gateway.id}"
}
