terraform {
  backend "s3" {
    bucket = "devops-101"
    key    = "path/key"
    region = "us-east-1"
  }
}
