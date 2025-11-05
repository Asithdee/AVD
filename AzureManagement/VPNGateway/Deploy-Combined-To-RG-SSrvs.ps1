param(
    [string]$ResourceGroupName = 'RG-SSrvs',
    [string]$TemplateFile = "$PSScriptRoot\template-combined.json",
    [string]$TemplateParametersFile = "$PSScriptRoot\template-combined.parameters.json",
    [string]$GatewayPublicIpName = '',
    [switch]$WhatIf
)

Write-Host "Deploying combined VPN gateway template to resource group: $ResourceGroupName"

if (-not (Get-AzContext)) {
    Write-Host "Not logged in. Please run Connect-AzAccount and re-run this script." -ForegroundColor Yellow
    return
}

# Read parameters from file (if present) into an object we can override
$location = 'eastus2'
$templateParamObject = @{}
try {
    if (Test-Path $TemplateParametersFile) {
        $p = Get-Content -Raw -Path $TemplateParametersFile | ConvertFrom-Json
        if ($p.parameters.location -and $p.parameters.location.value) { $location = $p.parameters.location.value }

        foreach ($name in $p.parameters.PSObject.Properties.Name) {
            $val = $p.parameters.$name.value
            $templateParamObject[$name] = $val
        }
    }
} catch {
    Write-Host "Warning: Could not read parameters file to infer parameters. Using defaults. Error: $_" -ForegroundColor Yellow
}

# Allow overriding the gateway public IP name to create a new zonal IP
if ($GatewayPublicIpName -and $GatewayPublicIpName.Trim() -ne '') {
    Write-Host "Overriding gatewayPublicIpName to: $GatewayPublicIpName" -ForegroundColor Cyan
    $templateParamObject['gatewayPublicIpName'] = $GatewayPublicIpName
}

try {
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if (-not $rg) { New-AzResourceGroup -Name $ResourceGroupName -Location $location | Out-Null }
} catch {
    Write-Host "Failed checking/creating resource group: $_" -ForegroundColor Red
    throw
}

if ($WhatIf) {
    Write-Host "Running WhatIf (no changes will be made)..." -ForegroundColor Cyan
    if ($templateParamObject.Count -gt 0) {
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $templateParamObject -WhatIf -Mode Incremental
    } else {
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParametersFile -WhatIf -Mode Incremental
    }
    return
}

# Validate and deploy
try {
    Write-Host "Validating template..."
    if ($templateParamObject.Count -gt 0) {
        Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $templateParamObject -ErrorAction Stop
    } else {
        Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParametersFile -ErrorAction Stop
    }
    Write-Host "Validation passed." -ForegroundColor Green
} catch {
    Write-Host "Template validation failed: $_" -ForegroundColor Red
    return
}

try {
    Write-Host "Starting deployment..."
    if ($templateParamObject.Count -gt 0) {
        $result = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $templateParamObject -Mode Incremental -Verbose -ErrorAction Stop
    } else {
        $result = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParametersFile -Mode Incremental -Verbose -ErrorAction Stop
    }
    Write-Host "Deployment finished. Provisioning state: $($result.ProvisioningState)" -ForegroundColor Green
} catch {
    Write-Host "Deployment failed: $_" -ForegroundColor Red
    throw
}
