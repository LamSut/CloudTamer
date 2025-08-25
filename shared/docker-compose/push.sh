#!/bin/bash
set -e

# Clone the repository if not already cloned
echo "Checking if the repository is already cloned..."
if [[ ! -d "containerize-full-stack-app-MERN-with-docker-compose" ]]; then
    git clone https://github.com/LamSut/PizzaGout.git repo
    echo "Repository cloned successfully."
else
    echo "Repository already cloned."
fi

# # Change to the cloned directory
# echo "Changing to the cloned directory..."
# cd containerize-full-stack-app-MERN-with-docker-compose

# # Login to AWS ECR
# echo "Logging in to AWS ECR..."
# aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-1.amazonaws.com

# # Build images
# echo "Building Docker images..."
# docker build -t backend ./server
# docker build -t frontend ./client

# # Push images to AWS ECR
# echo "Pushing Docker images to AWS ECR..."
# docker tag backend:v1 <AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-1.amazonaws.com/backend:v1
# docker tag frontend:v1 <AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-1.amazonaws.com/frontend:v1

# docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-1.amazonaws.com/backend:v1
# docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-1.amazonaws.com/frontend:v1
