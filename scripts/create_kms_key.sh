#!/bin/bash
REGION=${1:-us-east-1}
TRAIL_NAME=${2:-company-mr-trail}
KMS_ALIAS=${3:-alias/ct-logs}

KEY_ID=$(aws kms create-key \
    --description "KMS key for CloudTrail log encryption" \
    --region "$REGION" \
    --query KeyMetadata.KeyId \
    --output text)

aws kms create-alias \
    --alias-name "$KMS_ALIAS" \
    --target-key-id "$KEY_ID" \
    --region "$REGION"

echo "KMS Key created with ID: $KEY_ID and alias: $KMS_ALIAS"

aws kms put-key-policy \
    --key-id $KEY_ID \
    --policy file://../policies/kms-policy.json \
    --region "$REGION"

echo "KMS Key policy attached."