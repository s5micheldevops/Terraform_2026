locals {
  region         = "us-east-1"
  bucket_name    = "m5soft-tfstate-638458537700"
  dynamodb_table = "terraform-locks"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.bucket_name
    region         = local.region
    dynamodb_table = local.dynamodb_table
    encrypt        = true
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }
}

