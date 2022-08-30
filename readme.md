# Azure Static Web App With Terraform

## Why this tutorial
Neither Azure nor azurerm terraform clearly lay out **how to connect a terraform managed staticwebapp to a github repo using az cli**.  Azure docs for hooking this up assume the user wants to _create_ the infrastructure _and_ hook it up to GitHub, which is obviously not the case.  Azurerm simply gives a link to the aforementioned docs and leaves the user without a clear path to hook up the existing infrastructure to GitHub. 

**TLDR; Use `az staticwebapp upate`** to [Add GitHub Repo to staticwebapp](https://github.com/joshua-koehler/azure-staticwebapp-terraform#add-github-repo-to-staticwebapp) 

Through exploration of az staticwebapp submodules and trial and error, I figured out how to connect the repo after terraform deployment as well as how to modify the generated github actions workflow to deploy a vanilla js app successfully (it breaks by default).  It's my hope this will be useful to others working through similiar isues on their own.

## How I built and automate this
* Terraform defines infrastructure for staticwebapp
* AZ CLI script hooks up this repo to the staticwebapp
* Github actions automatically triggers deploy on push to repo

## Reference links
* [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps/overview) 
* [quickstart](https://docs.microsoft.com/azure/static-web-apps/getting-started?tabs=vanilla-javascript) to build and customize a new static site. (I did this my own way with terraform and cli commands but these docs are helpful nonetheless).

## Get up and running quickly 
Prerequisite dependencies
- az cli installed

1. Get a Github Personal Access Token (see Authentication below for details) and set as env var.
```
export GITHUB_TOKEN = "your token" 
```

2. Create a GitHub repo - forking mine is easiest but not necessary - just have a master branch
  - set the repourl variable in connectGitHubRepoToInfrastructure.sh to your GH repo

3. Run this script in a bash terminal to deploy everything with defaults
```
git clone https://github.com/joshua-koehler/terraform-azure-static-webapp
cd terraform-azure-static-webapp/terraform_infrastructure
az login
terraform init
terraform apply -auto-approve
bash ../devops/connectGitHubRepoToInfrastructure
```

4. Edit the auto-committed .github/workflows/azure-static-web-apps-xxxxxxxxxxx.yml file for your build specs and commit to your repo
  - see below for a simple edit for a vanilla js app 

## Tutorial - Follow along with each step and understand why

### Authentication

#### GitHub
[Generate GitHub personal access token](https://docs.github.com/en/enterprise-server@3.4/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) then set environment variable `export GITHUB_TOKEN="secret"`

This is passed as a param to the Azure CLI when hooking up the GitHub repo as the source of the staticwebapp.

#### Azure
Easiest way for local work is to authenticate using the azure cli as [recommended by azurerm terraform provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli).  Simply run az login and after logging in through the browser pop-up, you can run terraform commands fully authenticated.

> We recommend using either a Service Principal or Managed Service Identity when running Terraform non-interactively (such as when running Terraform in a CI server) - and authenticating using the Azure CLI when running Terraform locally.


##### Set subscrption id
List all your subscription ids:
```
az account show --query "[id,name,user.name]" -o jsonc
```

Select one via copy paste:
```
export subscriptionId="private"
```

If you only have one simply set it with this command
```
export subscriptionId=$(az account show --query id --output tsv)
```

##### Login

```
az login
az account set --subscription=$subscriptionId
```

### Deploy Infrastructure

Having logged in with az login above, cd into terraform_infrastructure/ directory and deploy with:
```
terraform init
terraform apply -auto-approve
```

### Add GitHub Repo to staticwebapp
```
az staticwebapp update --name $appname \
	--branch $branchname \
	--source $repourl \
	--token	$GITHUB_TOKEN \
	--output jsonc 
```

Note this will kick of a GitHub actions job which will create a workflow automatically configured to deploy your app.
.github/workflows/azure-static-web-apps-xxxxxxxxxxx.yml

Edit this yaml accordingly.  For a simple vanilla js webapp (no build required), update the yaml file:
```
app_location: "src" # App source code path relative to repository root
skip_app_build: true # no build required for vanilla js app, just upload app_location directory to static web app

```

It appears that the name of this file cannot be changed, though one can edit the file to merely be a "pass-through" as a [Reusable Workflow](https://docs.github.com/en/actions/learn-github-actions/reusing-workflows) to pass it's deployment secrets to call other workflows you define.  See a nice example of this [here](https://devkimchi.com/2021/12/01/refactoring-aswa-github-actions-workflow/) by @justinyoo with [accompanying github gist](https://gist.github.com/justinyoo/3f8de0ebaff5bdd7e41c961ed37b5b53).

### View the site
Get the generated site url from terraform with 
`terraform output default_host_name` or simply grab it from the GitHub Actions build from your repo url.
