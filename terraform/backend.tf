terraform {
  backend "s3" {
    # These values should be set via -backend-config or backend config file
    # Example: terraform init -backend-config="bucket=twin-terraform-state-ACCOUNT_ID" -backend-config="region=us-east-1"
    # Or create a backend.hcl file with these values
    
    # Required: S3 bucket name (created by bootstrap script)
    # bucket = "twin-terraform-state-ACCOUNT_ID"
    
    # Required: AWS region
    # region = "us-east-1"
    
    # State file key - will be automatically prefixed with env:/workspace-name/ when using workspaces
    # For workspaces: env:/dev/terraform.tfstate, env:/test/terraform.tfstate, etc.
    # key = "terraform.tfstate"
    
    # Optional: Enable encryption
    encrypt = true
    
    # Optional: Use lockfile instead of DynamoDB table (recommended for Terraform >= 1.0)
    use_lockfile = true
  }
}