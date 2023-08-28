$environment="dev"
$spnName="lm-spn-github-hrw-$environment"
$subscriptionId= "#<<< CHANGE_ME >>>" 
$resourceGroupName="lm-rg-hrw-$environment"

az ad sp create-for-rbac --name $spnName --role contributor `
    --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName `
    --sdk-auth