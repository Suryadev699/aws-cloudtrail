#!/bin/bash
REGION=${us-east-1}
TRAIL_NAME=${company-mr-trail}
BUCKET=${Provide bucket name}
KMS_ARN=${Provide full KMS Key ARN}

aws cloudtrail create-trail \
    --name "$TRAIL_NAME" \
    --s3-bucket-name "$BUCKET" \
    --is-multi-region-trail \
    --include-global-service-events \
    --kms-key-id "$KMS_ARN" \
    --region "$REGION"

aws cloudtrail start-logging --name "$TRAIL_NAME"
echo "CloudTrail $TRAIL_NAME created and logging started"

echo "Verifying CloudTrail status..."
aws cloudtrail get-trail-status --name "$TRAIL_NAME"
