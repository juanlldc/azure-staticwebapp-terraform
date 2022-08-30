cd terraform_infrastructure
az login
terraform init
terraform apply -auto-approve
bash ../devops/connectGitHubRepoToInfrastructure.sh
