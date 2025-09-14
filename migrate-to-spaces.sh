#!/bin/bash

# DigitalOcean Spaces State Migration Script
# This script helps you migrate Terraform state to DigitalOcean Spaces

set -e

echo "🚀 DigitalOcean Spaces State Migration"
echo "======================================"

# Check if credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ DigitalOcean Spaces credentials not set!"
    echo ""
    echo "Please set your DigitalOcean Spaces credentials:"
    echo ""
    echo "1. Go to: https://cloud.digitalocean.com/account/api/spaces"
    echo "2. Click 'Generate New Key'"
    echo "3. Give it a name like 'terraform-state-key'"
    echo "4. Copy the Access Key and Secret Key"
    echo ""
    echo "Then run (note: these use AWS_* names because Spaces is S3-compatible):"
    echo "export AWS_ACCESS_KEY_ID='your_spaces_access_key'"
    echo "export AWS_SECRET_ACCESS_KEY='your_spaces_secret_key'"
    echo ""
    echo "After setting credentials, run this script again:"
    echo "./migrate-to-spaces.sh"
    exit 1
fi

echo "✅ Spaces credentials found"
echo ""

# Verify bucket exists
echo "🔍 Verifying bucket access..."
if ! aws s3 ls s3://vk-terraform-state-bucket-doc/ --endpoint-url=https://nyc3.digitaloceanspaces.com > /dev/null 2>&1; then
    echo "❌ Cannot access bucket 'vk-terraform-state-bucket-doc'"
    echo "Please ensure:"
    echo "1. The bucket exists in DigitalOcean Spaces"
    echo "2. Your credentials have access to the bucket"
    echo "3. The bucket is in the 'nyc3' region"
    exit 1
fi

echo "✅ Bucket access verified"
echo ""

# Backup current state
echo "💾 Creating backup of current state..."
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
echo "✅ State backup created"
echo ""

# Migrate state
echo "🔄 Migrating state to DigitalOcean Spaces..."
echo "This will migrate your state from local storage to:"
echo "  Bucket: vk-terraform-state-bucket-doc"
echo "  Key: dev/terraform.tfstate"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Migration cancelled"
    exit 1
fi

# Initialize with migration
terraform init -migrate-state

echo ""
echo "✅ State migration completed successfully!"
echo ""

# Verify migration
echo "🔍 Verifying migration..."
terraform plan -var-file="envs/dev/infra.tfvars" > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Migration verified - Terraform is working with remote state"
    echo ""
    echo "🎉 Your Terraform state is now stored in DigitalOcean Spaces!"
    echo ""
    echo "📊 State location:"
    echo "  Bucket: vk-terraform-state-bucket-doc"
    echo "  Key: dev/terraform.tfstate"
    echo "  Region: nyc3"
    echo ""
    echo "🧹 You can now safely remove local state files:"
    echo "  rm terraform.tfstate*"
    echo "  rm -rf .terraform/terraform.tfstate.d/"
else
    echo "❌ Migration verification failed"
    echo "Please check the error above and try again"
    exit 1
fi
