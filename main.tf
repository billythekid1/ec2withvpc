provider "aws" {
   region = "us-east-1"
}

resource "aws_vpc" "mqb_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"

       tags {
        name = "mqb_vpc"
}
}
resource "aws_subnet" "mqb_subnet_public" {
  vpc_id = "${aws_vpc.mqb_vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
      tags {
        name = "mqb_subnet_public"
}
}
resource "aws_subnet" "mqb_subnet_private" {
  vpc_id = "${aws_vpc.mqb_vpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
      tags {
        name = "mqb_subnet_private"
}
}
resource "aws_internet_gateway" "mqb_internet_gateway" {
  vpc_id = "${aws_vpc.mqb_vpc.id}"
        tags {
         name = "mqb_internet_gateway"
}
}
resource "aws_route_table" "MQB_Public_route" {
   vpc_id = "${aws_vpc.mqb_vpc.id}"
}
resource "aws_route" "mqb_public_routetable" {
   route_table_id = "${aws_route_table.MQB_Public_route.id}"
   destination_cidr_block = "0.0.0.0/0"
   gateway_id     = "${aws_internet_gateway.mqb_internet_gateway.id}"
}
resource "aws_route_table_association" "subnet_addition" {
  subnet_id      = "${aws_subnet.mqb_subnet_public.id}"
  route_table_id = "${aws_route_table.MQB_Public_route.id}"
}
resource "aws_instance" "MQB_Server" {
        ami="ami-c998b6b2"
        instance_type="t2.micro"
        key_name = "USVirginia"
        subnet_id ="${aws_subnet.mqb_subnet_public.id}"
        vpc_security_group_ids = ["${aws_security_group.MQB_Dev_group.id}"]
}
resource "aws_security_group" "MQB_Dev_group" {
        name = "MQB_TEST"
        vpc_id = "${aws_vpc.mqb_vpc.id}"
 ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
}
}

                                                              
