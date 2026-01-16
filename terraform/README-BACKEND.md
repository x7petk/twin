# Terraform Backend Setup

## Problem

When running `terraform init`, you may encounter this error:
```
Error: Failed to get existing workspaces: S3 bucket "twin-terraform-state-***" does not exist.
```

This happens because the S3 bucket for storing Terraform state hasn't been created yet.

## Solution

### Step 1: Bootstrap the Backend

Run the bootstrap script to create the required AWS resources:

```bash
cd scripts
./bootstrap-terraform-backend.sh [environment] [project_name]
```

**Parameters:**
- `environment` (optional): Environment name (dev, test, prod). Default: `dev`
- `project_name` (optional): Project name. Default: `twin`

**Example:**
```bash
./bootstrap-terraform-backend.sh dev twin
```

This script will:
1. Get your AWS account ID
2. Create an S3 bucket for Terraform state (with versioning and encryption)
3. Create a DynamoDB table for state locking (optional, if not using `use_lockfile`)
4. Generate a backend config file: `terraform/backend-{environment}.hcl`

### Step 2: Initialize Terraform

After bootstrapping, initialize Terraform with the backend config:

```bash
cd terraform
terraform init -backend-config=backend-dev.hcl
```

Replace `backend-dev.hcl` with the appropriate file for your environment.

### Step 3: Continue with Deployment

Now you can proceed with normal Terraform operations:

```bash
terraform workspace select dev  # or create new workspace
terraform plan
terraform apply
```

## Backend Configuration

The backend uses:
- **S3** for storing state files
- **S3 Object Lock** (via `use_lockfile = true`) for state locking (Terraform >= 1.0)
- **Encryption** enabled by default

### Alternative: Using DynamoDB for Locking

If you prefer DynamoDB locking instead of S3 Object Lock, update `backend.tf`:

```hcl
terraform {
  backend "s3" {
    # ... other config ...
    dynamodb_table = "twin-terraform-locks"  # Instead of use_lockfile
  }
}
```

Note: The `dynamodb_table` parameter is deprecated in favor of `use_lockfile`, but still works.

## Troubleshooting

### Error: "Bucket already exists"
The bootstrap script will detect if the bucket exists and skip creation. This is safe.

### Error: "Access Denied"
Make sure your AWS credentials have permissions for:
- `s3:CreateBucket`, `s3:PutBucketVersioning`, `s3:PutBucketEncryption`
- `dynamodb:CreateTable` (if using DynamoDB locking)

### Error: "Region mismatch"
Make sure the region in your backend config matches the region where the bucket was created. The bootstrap script uses `us-east-1` by default, or the `AWS_REGION` environment variable.
