#!/bin/bash
set -e

# Usage check
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <cloud> <project> <env>"
  echo "Example: $0 aws vm-db dev"
  exit 1
fi

CLOUD=$1
PROJECT=$2
ENV=$3

WORKDIR="./examples/$CLOUD/$PROJECT"
BACKEND_FILE="./backend/${ENV}.conf"
TFVARS_FILE="./tfvars/${ENV}.tfvars"

echo "====================================="
echo " Cloud:   $CLOUD"
echo " Project: $PROJECT"
echo " Env:     $ENV"
echo "====================================="

cd "$WORKDIR"

# Initializing Terraform configuration
if [[ -f "$BACKEND_FILE" ]]; then
  echo "Initializing with backend config: $BACKEND_FILE"
  terraform init -backend-config="$BACKEND_FILE"
else
  echo "No backend config found for $ENV."
  echo "Please check README.md to create backend if required."
  terraform init
fi

# Destroying the infrastructure with Terraform
echo "Destroying infrastructure..."
if [[ -f "$TFVARS_FILE" ]]; then
  terraform destroy -var-file="$TFVARS_FILE"
else
  terraform destroy
fi

echo "Destroy complete"
