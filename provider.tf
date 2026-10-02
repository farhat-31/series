terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# No access keys here: Jenkins' EC2 IAM role supplies credentials.
provider "aws" {
  region = var.aws_region
}
