# CloudTamer
A reusable Terraform boilerplate for provisioning infrastructure on AWS, Azure and GCP, featuring built-in support for multi-cloud deployments. Contributions are welcome to improve this project.

## Setup
* Ensure a Terraform backend configuration file exists in each project: [Documentation](https://developer.hashicorp.com/terraform/language/backend)  
* Optionally, a `.tfvars` file can be added to define variable values: [Documentation](https://developer.hashicorp.com/terraform/language/values/variables)

<img width="1103" height="440" alt="image" src="https://github.com/user-attachments/assets/5186200a-15ba-4fe2-b71d-e09c8132078f" />

## Usage
* Provision the cloud infrastructure using Terraform:
```bash
$ ./provision.sh <cloud provider> <project> <environment>  # For example: ./provision aws vm-db dev 
```
* Tear down infrastructure using Terraform:
```bash
$ ./destroy.sh <cloud provider> <project> <environment>  # For example: ./destroy aws vm-db dev 
```
