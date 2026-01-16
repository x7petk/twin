#!/bin/bash
set -euo pipefail

# Bootstrap script to create Terraform state S3 bucket and DynamoDB table
# This must be run before the first terraform init

ENVIRONMENT=${1:-dev}
PROJECT_NAME=${2:-twin}
AWS_REGION=${AWS_REGION:-us-east-1}

echo "🔧 Bootstrapping Terraform backend for ${PROJECT_NAME} in ${ENVIRONMENT}..."

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ -z "$ACCOUNT_ID" ]; then
  echo "❌ Error: Could not get AWS account ID. Make sure AWS CLI is configured."
  exit 1
fi

echo "📋 AWS Account ID: ${ACCOUNT_ID}"
echo "🌍 AWS Region: ${AWS_REGION}"

# S3 bucket name for Terraform state
STATE_BUCKET="${PROJECT_NAME}-terraform-state-${ACCOUNT_ID}"
# Key for workspace-based state (Terraform will prefix with env:/workspace-name/)
STATE_KEY="terraform.tfstate"

# DynamoDB table name for state locking
LOCK_TABLE="${PROJECT_NAME}-terraform-locks"

echo ""
echo "📦 Creating S3 bucket: ${STATE_BUCKET}"

# Check if bucket already exists
if aws s3api head-bucket --bucket "${STATE_BUCKET}" 2>/dev/null; then
  echo "✅ S3 bucket ${STATE_BUCKET} already exists"
else
  # Create bucket
  if [ "$AWS_REGION" = "us-east-1" ]; then
    # us-east-1 doesn't need LocationConstraint
    aws s3api create-bucket \
      --bucket "${STATE_BUCKET}" \
      --region "${AWS_REGION}"
  else
    aws s3api create-bucket \
      --bucket "${STATE_BUCKET}" \
      --region "${AWS_REGION}" \
      --create-bucket-configuration LocationConstraint="${AWS_REGION}"
  fi

  # Enable versioning
  aws s3api put-bucket-versioning \
    --bucket "${STATE_BUCKET}" \
    --versioning-configuration Status=Enabled

  # Enable encryption
  aws s3api put-bucket-encryption \
    --bucket "${STATE_BUCKET}" \
    --server-side-encryption-configuration '{
      "Rules": [{
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }]
    }'

  # Block public access
  aws s3api put-public-access-block \
    --bucket "${STATE_BUCKET}" \
    --public-access-block-configuration \
      "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

  echo "✅ Created S3 bucket ${STATE_BUCKET}"
fi

echo ""
echo "🔒 Creating DynamoDB table: ${LOCK_TABLE} (optional - only needed if not using use_lockfile)"

# Check if table already exists
if aws dynamodb describe-table --table-name "${LOCK_TABLE}" --region "${AWS_REGION}" 2>/dev/null; then
  echo "✅ DynamoDB table ${LOCK_TABLE} already exists"
else
  # Create DynamoDB table for state locking (optional - we use use_lockfile by default)
  # Temporarily disable exit on error for this optional step
  set +e
  aws dynamodb create-table \
    --table-name "${LOCK_TABLE}" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "${AWS_REGION}" > /dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    # Wait for table to be active
    echo "⏳ Waiting for table to be active..."
    aws dynamodb wait table-exists \
      --table-name "${LOCK_TABLE}" \
      --region "${AWS_REGION}" > /dev/null 2>&1
    echo "✅ Created DynamoDB table ${LOCK_TABLE}"
  else
    echo "⚠️  Could not create DynamoDB table (permissions may be missing)"
    echo "   This is OK - Terraform will use S3 Object Lock (use_lockfile) instead"
  fi
  set -e
fi

# Create backend config file (shared across all environments since we use workspaces)
BACKEND_CONFIG_FILE="$(dirname "$0")/../terraform/backend.hcl"
cat > "${BACKEND_CONFIG_FILE}" <<EOF
bucket = "${STATE_BUCKET}"
key    = "${STATE_KEY}"
region = "${AWS_REGION}"
EOF

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "📝 Created backend config: terraform/backend.hcl"
echo ""
echo "🚀 Next steps:"
echo "   cd terraform"
echo "   rm -rf .terraform  # Clear cached backend config"
echo "   terraform init -backend-config=backend.hcl -reconfigure"
echo ""
