# GitHub repository details
$repoOwner = "LaTolva"
$repoName = "elprice"

# Login to GitHub
Write-Host "Logging in to GitHub..."
gh auth login --web

# Create repository if it doesn't exist
Write-Host "Creating GitHub repository if it doesn't exist..."
try {
    gh repo create "$repoOwner/$repoName" --public --confirm
} catch {
    Write-Host "Repository already exists"
}

# Check if we're already in a git repository
$gitStatus = git rev-parse --git-dir 2>&1
if ($LASTEXITCODE -ne 0) {
    # Initialize git repository
    Write-Host "Initializing git repository..."
    git init
    git branch -M main
    
    # Add GitHub remote
    Write-Host "Adding GitHub remote..."
    git remote add origin "https://github.com/$repoOwner/$repoName.git"
}

# Get the publish profile from Azure
Write-Host "Getting publish profile from Azure..."
$publishProfile = az webapp deployment list-publishing-profiles `
    --name "app-elprice" `
    --resource-group "rg-elprice-lasse" `
    --query "[?publishMethod=='MSDeploy']" `
    --output json

# Create the secret in GitHub
Write-Host "Creating GitHub secret..."
$publishProfileBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($publishProfile))
echo $publishProfileBase64 | gh secret set AZURE_WEBAPP_PUBLISH_PROFILE --repo="$repoOwner/$repoName"

Write-Host "Secret has been successfully added to GitHub repository!" 