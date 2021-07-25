# Flask on ECR Interview
Hello Jeffy!  Here you can read about the simple web app on ECR for the Pirate Assignment.

### Checklist
* [x] Terraform(grunt) ECR Repository
* [x] Terraform(grunt) DDB Table
* [x] Terraform(grunt) ECS
* [x] Containerize Python Flask App
* [x] Wrap everything in deployment script

# Infrastructure
Under this folder you can find all the infra supporting the web app.  Normally the "terraform_modules" would be a SysEng managed repo separate from this repo, so that we can keep the infra code clean and versioned.  All that would be required for apps are the terraform modules repo and setting up the minimal terragrunt configs (as you can see from the "prod" directory).

## Installation
Ensure AWS CLI is installed and configured 
```
aws configure
```

Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
```
brew install terragrunt
```
Install [Docker](https://docs.docker.com/get-docker/)


### Run deploy script
Include the stage and region you want to deploy to (check that the terragrunt dir for the stage and region exists first)
```
./deploy.sh prod eu-west-1
```

It'll poop out your ALB endpoint, then you can hit the endpoint '/hello/name'