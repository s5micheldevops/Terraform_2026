# Terraform block: defines Terraform settings and requirements
terraform {

  # Minimum Terraform version required to run this configuration
  required_version = ">= 1.0.0"

  # Providers required by this Terraform configuration
  required_providers {

    # AWS provider definition
    aws = {

      # Source of the AWS provider (HashiCorp registry)
      source = "hashicorp/aws"

      # AWS provider version constraint
      version = "~> 5.0"
    }
  }
}

# AWS provider configuration
provider "aws" {

  # AWS region where Terraform will make API calls
  region = "us-east-1"
}

# Data source that retrieves information about the
# AWS identity currently used by Terraform (who am I?)
data "aws_caller_identity" "me" {}

# Output the AWS account ID used by Terraform
output "account_id" {

  # The AWS account ID returned by the caller identity
  value = data.aws_caller_identity.me.account_id
}

# Output the full ARN of the IAM user or role
# that Terraform is authenticated as
output "caller_arn" {

  # The ARN (user or assumed role) returned by AWS
  value = data.aws_caller_identity.me.arn
}
