terraform {
  backend "s3" {
    bucket = "alfred-buildpack"        # my-s3-bucket
    key    = "buildpack/terraform.tfstate"
    region = "us-east-1"      # us-east-1, us-west-2 
  }
  required_version = ">=1.1.3"
}

provider "aws" {
  region = var.aws_region
}
