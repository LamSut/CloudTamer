# CloudTamer
A Terraform boilerplate for provisioning infrastructure on AWS, Azure and GCP.  
It offers built-in support for multi-cloud deployments.

## Get started
Change working directory to your desired project:
```bash
$ cd projects/<provider>/<project name>       # For example: cd /projects/aws/ec2-rds
```

## Introduction
Ensure a Terraform backend configuration file exists:
```bash
# backend.conf
bucket = "<the S3 bucket name>"               # For example: "tfbucket"
key    = "<state file path in S3>"            # For example: "tfstate"
region = "<AWS region of S3>"                 # For example: "ap-southeast-1"
```

Initialize Terraform and configure the backend:
```bash
$ terraform init -backend-config="<path>"     # For example: terraform init -backend-config="../backend.conf"
```

Preview the execution plan:
```bash
$ terraform plan
```

Apply the infrastructure changes:
```bash
$ terraform apply
```

Clean up the provisioned infrastructure when no longer needed:
```bash
$ terraform destroy
```
