#!/usr/bin/env bash

ENV=$1
REGION=$2
ROOT_DIR=$(pwd)

echo "=> Bootstrapping ECR"
cd infrastructure/$ENV/$REGION/ecr_hello_app
terragrunt apply --terragrunt-non-interactive 
[ $? -eq 0 ]  || exit 1

echo "=> Building app image"
cd $ROOT_DIR/app
ECR_REPO=$(aws ecr describe-repositories --repository-names hello-app-$REGION | grep repositoryUri | cut -d '"' -f4)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO
docker build -t hello-app .
docker tag hello-app:latest $ECR_REPO:latest
[ $? -eq 0 ]  || exit 1

echo "=> Pushing app image to $ECR_REPO"
docker push $ECR_REPO:latest
[ $? -eq 0 ]  || exit 1

echo "=> Deploying Infrastructure"
cd $ROOT_DIR/infrastructure/$ENV/$REGION
terragrunt run-all apply --terragrunt-non-interactive 
[ $? -eq 0 ]  || exit 1

