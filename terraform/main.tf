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
}


# Creating Subnets
resource "aws_subnet" "DevOps_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}



# Fetching the AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical
}


resource "aws_instance" "DevOps_instance" {
  ami           = data.aws.ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id

  tags = {
    Name = "DevOpsInstance"
  }
}