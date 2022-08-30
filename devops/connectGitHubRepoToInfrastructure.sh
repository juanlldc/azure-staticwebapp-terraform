#!/bin/bash
# Should match appname in terraform module (main.tf)
appname="azure-staticwebapp-terraform" 

# GitHub repo as your static webapp source
branchname="master"
repourl="https://github.com/<username>/<reponame>"

echo "logging in..." 
az login

# List your subscription ids - grab the one you want
# if you only have one subscription this command will set it automatically via query
subscriptionId=`az account show --query id --output tsv`

az account set --subscription=$subscriptionId

echo "attaching GitHub repo to staticwebapp..."
az staticwebapp update --name $appname \
	--branch $branchname \
	--source $repourl \
	--token	$GITHUB_TOKEN \
	--output jsonc 
