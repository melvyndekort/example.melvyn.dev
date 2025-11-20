variable "aws_region" {
  description = "Primary AWS region"
  type        = string
}

variable "aws_region_secondary" {
  description = "Secondary AWS region (us-east-1)"
  type        = string
}

variable "tfstate_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}
