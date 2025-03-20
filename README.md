# Electricity Price API

This project provides an API for retrieving electricity prices for a given time range. The API uses a machine learning model to predict prices based on historical data and various factors.

## Features

- REST API for electricity price predictions
- Machine learning model for price prediction
- Azure App Service deployment
- Infrastructure as Code using Azure Bicep
- Automated deployment using GitHub Actions

## Prerequisites

- Python 3.9 or higher
- Azure CLI
- PowerShell
- GitHub account
- Azure subscription

## Local Development

1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the application locally:
   ```bash
   uvicorn app.main:app --reload
   ```

## API Endpoints

### GET /
Health check endpoint

### POST /prices
Get electricity prices for a given time range.

Request body:
```json
{
    "start_time": "2024-01-01T00:00:00Z",
    "end_time": "2024-01-02T00:00:00Z"
}
```

Response:
```json
[
    {
        "timestamp": "2024-01-01T00:00:00Z",
        "price": 123.45
    },
    ...
]
```

## Deployment

### Initial Setup

1. Run the deployment script:
   ```powershell
   ./deploy.ps1
   ```
2. Follow the prompts to log in to Azure
3. Add the generated publish profile secret to your GitHub repository:
   - Go to your repository settings
   - Navigate to Secrets and Variables > Actions
   - Add a new secret named `AZURE_WEBAPP_PUBLISH_PROFILE`
   - Paste the value provided by the deployment script

### Automated Deployment

The application will automatically deploy to Azure App Service when you push to the main branch. The deployment is handled by GitHub Actions.

## Infrastructure

The infrastructure is defined using Azure Bicep templates in the `infrastructure` directory. The main components are:

- Azure App Service Plan
- Azure Web App
- Application settings and configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request 