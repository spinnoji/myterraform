provider "aws_instance" {
  region = "${var.region}"
}



resource "aws_vpc" "production-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  
  tags{
     Name = "Production-VPC" 
}
}
resource "aws_subnet" "public-subnet-1" {
  cidr_block = "${var.public_subnet_1_cidr}"
  vpc_id = "${aws_vpc.production-vpc.id}"
  availiability_zone = "ap-south-1a"
  
  
  tags{
    Name = "Public-subnet-1"
}
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block = "${var.public_subnet_2_cidr}"
  vpc_id = "${aws_vpc.production-vpc.id}"
  availiability_zone = "ap-south-1b"
  
  
  tags{
    Name = "Public-subnet-2"
}
}
  
  resource "aws_subnet" "public-subnet-3" {
  cidr_block = "${var.public_subnet_3_cidr}"
  vpc_id = "${aws_vpc.production-vpc.id}"
  availiability_zone = "ap-south-1a"
  
  
  tags{
    Name = "Public-subnet-3"
}
}

resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.production-vpc.id}"
	tags {
	  Name = "Public-Route-table"
}
}
resource "aws_route_table_association" "public-route-1-association"{
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-subnet-1.id}"
}
resource "aws_route_table_association" "public-route-2-association"{
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-subnet-2.id}"
}

resource "aws_route_table_association" "public-route-3-association"{
  route_table_id = "${aws_route_table.public-route-table.id}"
  subnet_id = "${aws_subnet.public-subnet-3.id}"
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block = "${var.private_subnet_1_cidr}"
  vpc_id = "${aws_vpc/production-vpc.id}"
  availiability _zone = "ap-south-1a"
  
  tags {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block = "${var.private_subnet_2_cidr}"
  vpc_id = "${aws_vpc/production-vpc.id}"
  availiability _zone = "ap-south-1b"
  
  tags {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  cidr_block = "${var.private_subnet_3_cidr}"
  vpc_id = "${aws_vpc/production-vpc.id}"
  availiability _zone = "ap-south-1a"
  
  tags {
    Name = "private-subnet-3"
  }
}


resource "aws_route_table" "private-route-table" {
  vpc_id = "${aws_vpc.production-vpc.id}"
  tags {
    Name = "Private-Route-Table"
  }
}


resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${aws_subnet.private-subnet-1.id}"
}


resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${aws_subnet.private-subnet-2.id}"
}


resource "aws_route_table_association" "private-route-3-association" {
  route_table_id = "${aws_route_table.private-route-table.id}"
  subnet_id      = "${aws_subnet.private-subnet-3.id}"
}


resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc = true
  association_with_private_ip = "10.0.0.5"
  
  tags {
    Name = "Production-EIP"
  }
}

resource "aws_nat_gateway" "nat=gw"{
  allocation_id = "${aws_eip.elastic-ip-for-nat-gw.id}"
  subnet_id = "${aws_subnet.public-subnet-1.id}"
  
  tags {
   Name = "Production-NAT-GW"
   }
   depends_on = ["aws_eip.elastic-ip-for-nat-gw"]
   
}

resource "aws_route" "nat-gw-route" {
  route_table_id         = "${aws_route_table.private-route-table.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat-gw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "production-igw" {
  vpc_id = "${aws_vpc.production-vpc.id}"
  tags {
    Name = "Production-IGW"
  }
}

resource "aws_route" "public-internet-igw-route" {
  route_table_id         = "${aws_route_table.public-route-table.id}"
  gateway_id             = "${aws_internet_gateway.production-igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}  
  