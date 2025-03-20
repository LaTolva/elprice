# Azure deployment parameters
$subscriptionId = "70c22c06-e2b0-434d-88b5-06c4a4e34cf0"
$resourceGroupName = "rg-elprice-lasse"
$location = "swedencentral"
$appName = "app-elprice"

# Login to Azure
Write-Host "Logging in to Azure..."
az login

# Set subscription
Write-Host "Setting subscription..."
az account set --subscription $subscriptionId

# Deploy resource group
Write-Host "Deploying resource group..."
az deployment sub create `
    --location $location `
    --template-file infrastructure/rg.bicep `
    --parameters resourceGroupName=$resourceGroupName location=$location

# Deploy app service resources
Write-Host "Deploying app service resources..."
az deployment group create `
    --resource-group $resourceGroupName `
    --template-file infrastructure/app.bicep `
    --parameters appName=$appName location=$location

# Get publish profile
Write-Host "Getting publish profile..."
$publishProfile = az webapp deployment list-publishing-profiles `
    --name $appName `
    --resource-group $resourceGroupName `
    --query "[?publishMethod=='MSDeploy'].{publishUrl:publishUrl,userName:userName,userPWD:userPWD,SQLServerDBConnectionString:SQLServerDBConnectionString,MySqlDBConnectionString:MySqlDBConnectionString,hostingProviderForumLink:hostingProviderForumLink,controlPanelLink:controlPanelLink,webSystem:webSystem}" `
    --output json

# Save publish profile to file
$publishProfile | Out-File -FilePath "publish-profile.json" -Encoding UTF8

# Create GitHub secret
Write-Host "Creating GitHub secret..."
$publishProfileContent = Get-Content -Path "publish-profile.json" -Raw
$publishProfileBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($publishProfileContent))

# Note: You'll need to manually add this secret to your GitHub repository
Write-Host "Please add the following secret to your GitHub repository:"
Write-Host "Name: AZURE_WEBAPP_PUBLISH_PROFILE"
Write-Host "Value: $publishProfileBase64"

# Clean up
Remove-Item "publish-profile.json"

Write-Host "Deployment completed successfully!"
Write-Host "Please add the publish profile secret to your GitHub repository before pushing code." 