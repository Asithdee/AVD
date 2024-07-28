#Disable PrivateLinkServiceNetworkPolicies for Custom Image builder subnet
$vnetName ="vnet-eus2"
$vnetRgName ="AVD-RG"
$subnetName ="images"

$virtualNetwork= Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $vnetRgName 
   
($virtualNetwork | Select -ExpandProperty subnets | Where-Object  {$_.Name -eq $subnetName} ).privateLinkServiceNetworkPolicies = "Disabled"  
 
$virtualNetwork | Set-AzVirtualNetwork

#Check PrivateLinkServiceNetworkPolicies disabled or not

$net = Get-AzVirtualNetwork -Name AVD-VNET -ResourceGroupName AVD-RG  
Get-AzVirtualNetworkSubnetConfig -Name images -VirtualNetwork $net
