# Setup Variables.
$environment="devtest"
$appEnvironment="dev"
$subscriptionId="#<<< CHANGE_ME >>>"  
$resourceGroupName="az-lx-rg-tf-hrw-$environment"
$appResourceGroupName="az-lx-rg-hrw-$appEnvironment"
$storageName="azlxsttfhrw$environment"
$spnName="lm-spn-tf-hrw-$environment"
$region = "westeurope"

#Log into Azure
az login
az account set -s "$subscriptionId"

# Create a resource resourceGroupName
az group create --name "$resourceGroupName" --location "$region"

# Create an azure storage account - Terraform Backend Storage Account
az storage account create `
    --name $storageName `
    --resource-group $resourceGroupName `
    --access-tier Hot `
    --location $region `
    --sku Standard_LRS `
    --kind StorageV2 `
    --https-only true `
    --min-tls-version TLS1_2 `
    --allow-blob-public-access false `
    --allow-cross-tenant-replication true `
    --allow-shared-key-access "false" `
    --enable-hierarchical-namespace false `
    --public-network-access Enabled `
    --require-infrastructure-encryption false `
    --bypass AzureServices `
    --default-action Allow `
    --enable-alw false 
 
az storage account blob-service-properties update `
    --account-name $storageName `
    --resource-group $resourceGroupName `
    --enable-change-feed true `
    --enable-restore-policy true `
    --restore-days 6 `
    --container-retention true `
    --container-days 7 `
    --enable-delete-retention true `
    --delete-retention-days 7 `
    --enable-versioning true

az storage account update `
    --name $storageName `
    --resource-group $resourceGroupName `
    --add defaultToOAuthAuthentication false

#In preview
# az storage account update `
#     --name $storageName `
#     --resource-group $resourceGroupName `
#     --add allowedCopyScope PrivateLink

# Authorize the operation to create the container - Signed in User (Storage Blob Data Contributor Role)
az ad signed-in-user show --query id -o tsv | foreach-object {
    az role assignment create `
        --role "Storage Blob Data Contributor" `
        --assignee "$_" `
        --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageName"
    }

#Create Upload container in storage account to store terraform state files
Start-Sleep -s 40
az storage container create `
    --account-name "$storageName" `
    --name "tfstate" `
    --auth-mode login `
    --public-access off

# Create Terraform Service Principal 
$spnJSON = az ad sp create-for-rbac --name $spnName `
    --role "Storage Blob Data Contributor" `
    --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageName `
    --sdk-auth

# Assign additional RBAC role to Terraform Service Principal Subscription as Contributor and access to app resource group
az ad sp list --display-name $spnName --query [].appId -o tsv | ForEach-Object {
    az role assignment create --assignee "$_" `
        --role "Owner" `
        --subscription $subscriptionId `
        --resource-group $appResourceGroupName
    }

Write-Host $spnJSON