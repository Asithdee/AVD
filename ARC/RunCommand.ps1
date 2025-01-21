Install-Module -Name Az.ConnectedMachine -Scope CurrentUser -AllowClobber -Force

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module -Name Az -Repository PSGallery -Force

#### Update ARC Agent

# Login to Azure
Connect-AzAccount

# Set the subscription context
Set-AzContext -SubscriptionName "ME-MngEnvMCAP855772-adesilva-1"
# Get all Azure Arc servers in the specified resource group
$arcServers = Get-AzConnectedMachine -ResourceGroupName "RG-AzureARC"
# Filter servers with agent version below 1.48.02881.1941 and status "connected"
$filteredServers = $arcServers | Where-Object {
    [version]$_.AgentVersion -lt [version]"1.48.02881.1941" -and $_.Status -eq "connected"
}

# Output the filtered servers
#$filteredServers | Select-Object Name, AgentVersion, Status

# New-AzConnectedMachineRunCommand -ResourceGroupName ARC -MachineName PUB2 -RunCommandName arcagupd01 -Location CentralUS  -SourceScriptUri "https://sharexvolkbike.blob.core.windows.net/scripts/arcagent.ps1?sp=r&st=2025-01-16T19:28:19Z&se=2025-01-30T03:28:19Z&spr=https&sv=2022-11-02&sr=b&sig=E%2F0Y8pH%2FbirvP1Te0XJtbNGB%2FH38vcsZ4O%2FJZ2bDdl8%3D"

# Loop through the filtered servers and execute the run command
foreach ($server in $filteredServers) {
    New-AzConnectedMachineRunCommand -ResourceGroupName $server.ResourceGroupName `
    -MachineName $server.Name `
    -RunCommandName "arcagupd03" `
    -Location $server.Location `
    -SourceScriptUri "https://stkandyavd.blob.core.windows.net/apps/firefoxinstall.ps1" `
    -AsJob
}
