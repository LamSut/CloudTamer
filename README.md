# CloudTamer
A Terraform boilerplate for provisioning infrastructure on AWS, Azure and GCP.  
It offers built-in support for multi-cloud deployments.

## Introduction
Ensure a Terraform backend configuration file exists:
* Backend storage with S3:
```bash
# examples/aws/vm-db/backend/dev.conf
bucket = "<the S3 bucket name>"               # For example: "tfbucket"
key    = "<state file path in S3>"            # For example: "path/to/tfstate"
region = "<AWS region of S3>"                 # For example: "ap-southeast-1"
```
* Backend storage with GCS:
```bash
# examples/aws/vm-db/backend/dev.conf
bucket = "<the GCS bucket name>"                    # For example: "tfbucket"
prefix = "<prefix of state file path in GCS>"       # For example: "path/to"
```
