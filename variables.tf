variable "region" {
  description = "The AWS region to deploy resources."
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g., Dev, Staging, Prod)."
  type        = string
  default     = "Dev"
}

variable "public_subnets_cidrs" {
  description = "List of public subnets."
  type        = list(string)
  default     = ["10.0.10.0/24"]
}

variable "private_subnets_cidrs" {
  description = "List of private subnets."
  type        = list(string)
  default     = []
}

locals {
  instance_size = {
    micro  = "t2.micro"
    small  = "t2.small"
  }
  instance_meta = {
    ssh_user    = "ubuntu"
    key_name    = "ServersKey"
    # private_key = file("~/.ssh/ServersKey.pem")
    environment = var.environment
  }
  common_tags = {
    Owner       = "Valerii Vasianovych"
    ProjectID   = "Terraform Cloud"
    environment = local.instance_meta.environment
  }
}
