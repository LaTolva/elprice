# Azure App Service details
$appName = "app-elprice"
$resourceGroup = "rg-elprice-lasse"

# Get the publish profile
Write-Host "Getting publish profile from Azure..."
$publishProfile = az webapp deployment list-publishing-profiles `
    --name $appName `
    --resource-group $resourceGroup `
    --query "[?publishMethod=='MSDeploy'].{publishUrl:publishUrl,userName:userName,userPWD:userPWD,SQLServerDBConnectionString:SQLServerDBConnectionString,MySqlDBConnectionString:MySqlDBConnectionString,hostingProviderForumLink:hostingProviderForumLink,controlPanelLink:controlPanelLink,webSystem:webSystem}" `
    --output json

# Save to file
$publishProfile | Out-File -FilePath "publish-profile.json" -Encoding UTF8

Write-Host "Publish profile has been saved to publish-profile.json"
Write-Host "Please copy the contents of this file and add it as a secret named AZURE_WEBAPP_PUBLISH_PROFILE in your GitHub repository" 