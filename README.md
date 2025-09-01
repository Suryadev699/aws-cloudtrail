# AWS Multi-Region CloudTrail Setup

This repository automates the setup of a **multi-region CloudTrail** in AWS with secure logging for compliance purposes. It captures **all AWS API activity**, including IAM, CloudFront, AWS WAF, and Route 53, and stores logs in an encrypted, versioned S3 bucket.

## Features

- Multi-region CloudTrail that tracks **all regions**
- Includes **global service events**
- S3 bucket with:
  - Versioning enabled
  - Public access blocked
  - Optional MFA Delete (can be enabled manually)
- KMS encryption for logs
- Secure bucket policy granting CloudTrail access only
- Test scripts to verify log capture

## Repository Structure

```

aws-cloudtrail-multiregion/
├── README.md
├── scripts/
│   ├── create_kms_key.sh       # Script to create a KMS key
│   ├── create_s3_bucket.sh     # Script to create and secure S3 bucket
│   ├── create_cloudtrail.sh    # Script to create CloudTrail trail
│   └── test_cloudtrail.sh      # Script to test logs
├── policies/
│   ├── kms-policy.json         # KMS key policy
│   └── bucket-policy.json      # S3 bucket policy
└── .gitignore                  # Ignore sensitive files/logs

````

## Usage

### 1. Create KMS Key
```bash
bash scripts/create_kms_key.sh <region> <trail_name> <kms_alias>
````

* Creates a Customer Managed KMS key for CloudTrail encryption.
* Creates a readable alias for convenience.

### 2. Create S3 Bucket

```bash
bash scripts/create_s3_bucket.sh <region> <bucket_name>
```

* Creates a bucket for CloudTrail logs.
* Enables versioning and blocks public access.
* Applies the pre-defined bucket policy.

### 3. Create CloudTrail

```bash
bash scripts/create_cloudtrail.sh <region> <trail_name> <bucket_name> <kms_key_arn>
```

* Creates a multi-region CloudTrail trail.
* Includes global service events.
* Starts logging automatically.
* Encrypts logs using the specified KMS key.

### 4. Test CloudTrail

* Perform a test action, e.g., create an IAM user:

```bash
aws iam create-user --user-name TestUserVerify
```

* Check logs in S3:

```bash
aws s3 ls s3://<bucket_name>/AWSLogs/<account_id>/CloudTrail/ --recursive
```

* Download and inspect the latest log to confirm the action was recorded.

## Notes

* Replace placeholders like `<region>`, `<bucket_name>`, `<kms_key_arn>` with your actual values.
* MFA Delete is optional but recommended for compliance; it requires root account credentials.
* Log file validation can be enabled later for extra integrity verification:

```bash
aws cloudtrail update-trail --name <trail_name> --enable-log-file-validation
```

## Security & Compliance

* Logs are encrypted at rest using KMS.
* Bucket access is restricted to CloudTrail and your account.
* Public access is fully blocked.
* Versioning ensures logs cannot be overwritten accidentally.

## License

This repository is provided as-is for educational and compliance automation purposes.

```