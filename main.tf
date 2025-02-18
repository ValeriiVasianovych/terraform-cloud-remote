provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a"]
  public_subnets  = var.public_subnets_cidrs
  private_subnets = var.private_subnets_cidrs

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, {
    Terraform = "true"
    Name      = "vpc"
  })
}