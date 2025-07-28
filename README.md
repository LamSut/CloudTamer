# CloudTamer
A reusable Terraform boilerplate for multi-cloud infrastructure provisioning across AWS, Azure, and GCP.  
## Introduction
Change working directory to your desired project:
```bash
cd projects/<provider>/<project>/<env>
```
Initialize Terraform and download required providers:
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
## Cleanup
Terminate the provisioned infrastructure:
```bash
cd projects/<provider>/<project>/<env>
terraform destroy
```
