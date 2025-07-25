terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   alias   = "brr-tools"
#   region  = "us-east-2"
#   profile = "default"
# }

provider "aws" {
  # alias   = "brr-np"
  region  = "us-east-2"
  profile = "brr-np-admin"
}