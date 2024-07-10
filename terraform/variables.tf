variable "region" {
  type = string
  default = "us-east-1"

}

variable "cidar_block" {
    type = string
    default = "10.0.0.0/16"
  
}


variable "availability_zone" {
    type = string
    default = "us-east-1a"
  
}

variable "subnet" {
    type = string
    default = "10.0.1.0/24"
  
}