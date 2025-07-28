# CloudTamer
A reusable Terraform boilerplate for provisioning infrastructure on AWS, Azure, and GCP with built-in support for multi-cloud deployments.  

## Get started
Change working directory to your desired project:
```bash
cd projects/<provider>/<project>/<env>
```

## Introduction

Initialize Terraform and configure the backend:
```bash
terraform init
```

Preview the execution plan:
```bash
terraform plan
```

Apply the infrastructure changes:
```bash
terraform apply
```

Clean up the provisioned infrastructure when no longer needed:
```bash
terraform destroy
```
