# GitHub Actions Deployment Setup

This repository includes automated deployment via GitHub Actions. When you push to `main` or `master`, it will automatically deploy your application to AWS.

## Setup Instructions

### 1. Add AWS Credentials to GitHub Secrets

Go to your repository settings → Secrets and variables → Actions, and add:

- `AWS_ACCESS_KEY_ID` - Your AWS access key ID
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret access key

**Important:** Make sure the IAM user has the following permissions:
- Lambda (create, update, invoke)
- API Gateway (create, update, deploy)
- S3 (read, write, sync)
- CloudFront (create, update, invalidate)
- IAM (read roles, attach policies)
- Terraform state bucket access

### 2. Ensure Backend Config Exists

Make sure `terraform/backend.hcl` exists with your S3 backend configuration. If it doesn't, run:

```bash
./scripts/bootstrap-terraform-backend.sh dev twin
```

### 3. Push to Main Branch

The workflow will automatically trigger on push to `main` or `master`:

```bash
git add .
git commit -m "Deploy via GitHub Actions"
git push origin main
```

### 4. Manual Deployment

You can also trigger deployments manually:
- Go to Actions tab in GitHub
- Select "Deploy to AWS" workflow
- Click "Run workflow"

## Workflow Details

The deployment workflow:
1. ✅ Builds Lambda package with Python dependencies
2. ✅ Builds Next.js frontend
3. ✅ Initializes Terraform
4. ✅ Applies infrastructure changes
5. ✅ Syncs frontend to S3
6. ✅ Shows deployment summary

## Environment Detection

- **Main/Master branch** → Deploys to `prod` environment
- **Other branches** → Deploys to `dev` environment

## Troubleshooting

### Authentication Errors
- Verify AWS credentials are correct in GitHub Secrets
- Check IAM user has required permissions

### Terraform Errors
- Ensure `terraform/backend.hcl` exists
- Check S3 bucket for Terraform state exists
- Verify backend configuration is correct

### Build Errors
- Check Node.js and Python versions match requirements
- Verify all dependencies are in `package.json` and `requirements.txt`
