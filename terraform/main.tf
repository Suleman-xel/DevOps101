terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}



provider "aws" {
  region = "us-east-1"
}


# Creating VPC
resource "aws_vpc" "DevOps_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "DevOpsVPC"
  }
}


# Creating Subnets
resource "aws_subnet" "DevOps_subnet" {
  vpc_id     = aws_vpc.DevOps_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "DevOpsSUBNET"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "DevOps_igw" {
  vpc_id = aws_vpc.DevOps_vpc.id

  tags = {
    Name = "DevOpsInternetGateway"
  }
}

# Create a Route Table
resource "aws_route_table" "DevOps_rt" {
  vpc_id = aws_vpc.DevOps_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DevOps_igw.id
  }

  tags = {
    Name = "DevOpsRouteTable"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "DevOps_rta" {
  subnet_id      = aws_subnet.DevOps_subnet.id
  route_table_id = aws_route_table.DevOps_rt.id
}


# Inbound and Outbound Security
resource "aws_security_group" "DevOps_sg" {
  name        = "DevOpsSecurityGroup"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.DevOps_vpc.id

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
    Name = "DevOpsSG"
  }
}



# Fetching the AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


# Resources Destribution
resource "aws_instance" "DevOps_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.DevOps_subnet.id
  key_name      = "devopsKEY"
  vpc_security_group_ids = [aws_security_group.DevOps_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "DevOpsInstance"
  }
  
}


output "instance_public_ip" {
  value = aws_instance.DevOps_instance.public_ip
}
