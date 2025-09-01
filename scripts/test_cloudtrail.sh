echo "Starting CloudTrail Test..."
aws cloudtrail start-logging --name "$TRAIL_NAME"

echo "Performing a test event..."
aws ec2 describe-instances
aws iam create-user --user-name TestUser
aws cloudfront list-distributions

sleep 60

echo "verifying CloudTrail Logs from S3 Bucket"
aws s3 ls s3://$BUCKET/AWSLogs/$ACCOUNT_ID/CloudTrail/$REGION/ --recursive

echo "Copying latest CloudTrail log file..."
LATEST_LOG=$(aws s3 ls s3://$BUCKET/AWSLogs/$ACCOUNT_ID/CloudTrail/us-east-1/ --recursive | tail -n 1 | awk '{print $4}')
aws s3 cp s3://$BUCKET/$LATEST_LOG .
gunzip $(basename $LATEST_LOG)
grep "TestUser" $(basename $LATEST_LOG .gz)
