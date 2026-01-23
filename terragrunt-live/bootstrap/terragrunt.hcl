terraform {
  source = "../modules/backend"
}

inputs = {
  region         = "us-east-1"
  bucket_name    = "m5soft-tfstate-638458537700"
  dynamodb_table = "terraform-locks"
}
