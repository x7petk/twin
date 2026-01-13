terraform {
  backend "s3" {
    bucket         = "twin-terraform-state-021399177462"
    key            = "env/dev/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "twin-terraform-locks"
    encrypt        = true
  }
}
