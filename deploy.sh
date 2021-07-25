#!/usr/bin/env bash

ENV=$1
REGION=$2

echo "=> Deploying Infrastructure"
cd infrastructure/$ENV/$REGION
terragrunt run-all apply --terragrunt-non-interactive 
[ $? -eq 0 ]  || exit 1

echo "=> Building app image"
cd ../../../app
ECR_REPO=$(aws ecr describe-repositories --repository-names hello-app | grep repositoryUri | cut -d '"' -f4)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO
docker build -t hello-app .
docker tag hello-app:latest $ECR_REPO:latest
docker push $ECR_REPO:latest