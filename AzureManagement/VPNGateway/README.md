Overview

---------- this will create VPN Gateway, Local Network Gateway and Connection -----
Just run .\AzureManagement\VnetGateway\Deploy-Combined-To-RG-SSrvs.ps1
After deployed makesure to refresh preshared key again----------------------------------------


This folder contains an ARM template and a small PowerShell wrapper to deploy a VPN setup into the `RG-SSrvs` resource group. The combined template provisions (in order):

1. A Public IP (unless you supply an existing Public IP resourceId)
2. A Virtual Network Gateway (VPN gateway) that uses the VNet's `GatewaySubnet`
3. A Local Network Gateway (on-prem peer)
4. A Connection between the VPN gateway and the Local Network Gateway

Files

- `template-combined.json` — ARM template that creates the resources described above. Key parameters are documented below.
- `template-combined.parameters.json` — Parameter file with sensible defaults for RG-SSrvs/VNET-HUB. Edit values here if needed.
- `Deploy-Combined-To-RG-SSrvs.ps1` — PowerShell wrapper that validates, optionally WhatIf, and deploys the template to `RG-SSrvs`.
- `README.md` — this file.

Important parameters (in `template-combined.parameters.json`)

- `vnetResourceId` (string, required) — Full resourceId of the virtual network which contains the `GatewaySubnet`.
  Example: `/subscriptions/<sub>/resourceGroups/RG-SSrvs/providers/Microsoft.Network/virtualNetworks/VNET-HUB`

- `gatewayPublicIpResourceId` (string, optional) — If set to a full public IP resourceId, the template will use that existing public IP (recommended if you already created `gw-pip-2`). If empty, the template will create a new public IP using `gatewayPublicIpName` and `gatewayPublicIpZones`.
  Example: `/subscriptions/<sub>/resourceGroups/RG-SSrvs/providers/Microsoft.Network/publicIPAddresses/gw-pip-2`

- `gatewayPublicIpName` (string) — Name to use when creating a new Public IP (ignored if `gatewayPublicIpResourceId` is set).

- `gatewayPublicIpZones` (array) — Zone(s) to place the public IP in (required for AZ VPN SKUs such as `VpnGw2AZ`). Default: `["1"]`.

- `gatewaySkuName` (string) — Gateway SKU. Example: `VpnGw2AZ` (AZ SKU). If you want to use an existing regional public IP you can use a non-AZ SKU like `VpnGw2`.

- `gatewayName`, `localGatewayName`, `localGatewayIp`, `localGatewayAddressPrefixes`, `connectionName`, `location` — other standard values; see `template-combined.parameters.json`.

Quick start (recommended)

1. Ensure you are signed in and have the Az PowerShell module available:

```powershell
Connect-AzAccount
```

2. Optional: Inspect existing public IP (if you plan to use it):

```powershell
Get-AzPublicIpAddress -ResourceGroupName RG-SSrvs -Name gw-pip-2 | Format-List Name, Sku, Zones, IpAddress, Id
```

3. Dry-run (WhatIf) to validate the deployment won't produce unexpected changes:

```powershell
.\\AzureManagement\VnetGateway\Deploy-Combined-To-RG-SSrvs.ps1 -WhatIf
```

4. If you want to force usage of an existing public IP resource (no creation), set `gatewayPublicIpResourceId` inside `template-combined.parameters.json` to the full resource id (example shown above). By default the parameter file already points to `gw-pip-2` in `RG-SSrvs`.

5. Full deploy (creates or references resources according to parameters):

```powershell
.\AzureManagement\VnetGateway\Deploy-Combined-To-RG-SSrvs.ps1
```

If you want to create a new zonal public IP (instead of editing the parameters file) you can override the name on the command line:

```powershell
.\AzureManagement\VnetGateway\Deploy-Combined-To-RG-SSrvs.ps1 -GatewayPublicIpName 'gw-pip-3'
```

Notes and preconditions

- The template assumes the `GatewaySubnet` already exists in the VNet referenced by `vnetResourceId`. Create it first if missing:

```powershell
# Example: add GatewaySubnet if needed
$vnet = Get-AzVirtualNetwork -ResourceGroupName RG-SSrvs -Name VNET-HUB
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix '10.255.255.0/27' -VirtualNetwork $vnet
Set-AzVirtualNetwork -VirtualNetwork $vnet
```

- If you changed `gatewayPublicIpResourceId` from empty to an existing public IP, the template will reference that IP; ensure the IP's zones and SKU match the gateway SKU requirements.

- If you need no downtime and do not want to delete the existing regional `gw-pip`, use a new public IP name (or existing zonal IP) and create a new gateway; then cut over traffic when ready.

Post-deployment checks

Check that the gateway reached the `Succeeded` provisioning state:

```powershell
Get-AzVirtualNetworkGateway -ResourceGroupName RG-SSrvs -Name <gatewayName> | Format-List Name, ProvisioningState
```

Check the connection:

```powershell
Get-AzVirtualNetworkGatewayConnection -ResourceGroupName RG-SSrvs -Name <connectionName> | Format-List Name, ProvisioningState, ConnectionStatus
```

If you need help with cutover steps or automating verification (wait/poll until the gateway is `Succeeded`), tell me and I will add that to the wrapper script.

Support

If the deployment fails, paste the `New-AzResourceGroupDeployment` error message here and I will help troubleshoot. Include the resourceId shown in the error and any partially-created resource names.
