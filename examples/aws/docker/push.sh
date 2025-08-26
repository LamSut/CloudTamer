#!/bin/bash
set -e

echo "Starting ECR push process..."

AWS_REGION=$1
ACCOUNT_ID=$2
shift 2
REPOS=("$@")

echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "Navigating to the cloned repository..."
if [[ ! -d "repo" ]]; then
    echo "Error: 'repo' directory does not exist. Please run the get.sh script first."
    exit 1
else
    cd repo
fi

echo "Building Docker images using docker-compose..."
docker compose build

for repo_pair in "${REPOS[@]}"; do
  REPO_NAME=$(echo $repo_pair | cut -d: -f1)
  LOCAL_IMAGE=$(echo $repo_pair | cut -d: -f2)
  VERSION=$(echo $repo_pair | cut -d: -f3)

  echo "Tagging image ${LOCAL_IMAGE}:${VERSION} as ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${VERSION}"
  docker tag ${LOCAL_IMAGE}:${VERSION} ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${VERSION}

  echo "Pushing image for repo ${REPO_NAME}..."
  docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${VERSION}
done

echo "ECR push process completed successfully."
