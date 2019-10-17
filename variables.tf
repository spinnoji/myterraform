variable "region"{
  default= "ap-south-1" 
}  
variable "vpc_cidr" {
  description= "CIDR block for VPC"
}  
variable "public_subnet_1_cidr" {
    description = "CIDR block for Public subnet 1"
}
variable "public_subnet_2_cidr"	{
   description = "CIDR block for Public Subnet 2"
}   
variable "public _subnet_3_cidr"{
  description = "CIDR block for public subnet 3"
}   
variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
}

variable "private_subnet_3_cidr" {
  description = "CIDR block for Private Subnet 3"
}

