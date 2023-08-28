# Setup Variables.
$environment= "dev"
$subscriptionId= "#<<< CHANGE_ME >>>" 
$resourceGroupName = "az-lx-rg-hrw-$environment"
$region = "westeurope"

#Log into Azure
az login
az account set -s "$subscriptionId"

# Create a resource resourceGroupName
az group create --name "$resourceGroupName" --location "$region"