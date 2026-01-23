terraform {
  # Pin Terraform to avoid surprises
  required_version = ">= 1.13.0, < 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type        = string
  description = "AWS region where the backend resources will be created."
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket that will store Terraform state."
}

variable "dynamodb_table" {
  type        = string
  description = "Name of the DynamoDB table that will be used for state locking."
}

resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name

  # Prevent accidental deletion of your state bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket_name" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "S3 bucket used for Terraform remote state."
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.locks.name
  description = "DynamoDB table used for Terraform state locking."
}
