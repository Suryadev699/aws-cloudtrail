#!/bin/bash
REGION=${us-east-1}
BUCKET=${Provide bucket name}

aws s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$REGION" 2>/dev/null || echo "Bucket may already exist in this region"

aws s3api put-public-access-block \
    --bucket "$BUCKET" \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

aws s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled

aws s3api put-bucket-policy \
    --bucket "$BUCKET" \
    --policy file://../policies/bucket-policy.json

echo "S3 Bucket created and secured: $BUCKET"
