$newComputerName = "DC1"
$netAdapterName1 = "Ethernet0"
$netAdapterName2 = "Ethernet1"
$newNetAdapterName1 = "Public"
$newNetAdapterName2 = "Private"
$interfaceIndex = "3"
$ipv4Address = "192.168.130.190"
$ipv4PrefixLength = "26"
$ipv4DefaultGateway = $ipv4Address

$ipv6Address = "2001:CC1D:5A:C007::1"
$ipv6PrefixLength = "64"
$ipv6DefaultGateway = $ipv6Address

Rename-Computer -NewName $newComputerName
Rename-NetAdapter -Name $netAdapterName1 -NewName $newNetAdapterName1
Rename-NetAdapter -Name $netAdapterName2 -NewName $newNetAdapterName2
New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ipv4Address -PrefixLength $ipv4PrefixLength -DefaultGateway $ipv4DefaultGateway
New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ipv6Address -PrefixLength $ipv6PrefixLength -DefaultGateway $ipv6DefaultGateway
Install-WindowsFeature "DNS" –IncludeManagementTools
<#
Restart-Computer #run this line after the other things have finished
#>