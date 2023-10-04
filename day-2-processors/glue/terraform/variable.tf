variable "region" {
  description = "aws region"
  default     = "us-east-2"
}

variable "account_id" {
  default = 777696598735
}

variable "environment" {
  default = "dev"
}

variable "prefix" {
  description = "objects prefix"
  default     = "owshq"
}

# Prefix configuration and project common tags
locals {
  glue_bucket = "${var.prefix}-scripts-${var.environment}-${var.account_id}"
  prefix      = var.prefix
  common_tags = {
    Environment = "dev"
    Project     = "trn-cc-bg-aws"
  }
}