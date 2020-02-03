$ipv4DHCPScopeName = "DHCP Scope"
$ipv4StartRange = "192.168.130.129"
$ipv4EndRange = "192.168.130.159"
$ipv4SubnetMask = "255.255.255.192"
$ipv4DNSServerIP = "192.168.130.190"
$ipv4DefaultGateway = $ipv4DNSServerIP
$ipv4DHCPScopeID = $ipv4DNSServerIP
$ipv4LeaseDuration = "7.00:00:00"

$ipv6DHCPScopeName = "DHCPv6 Scope"
$ipv6Prefix = "2001:CC1D:005A:C007::"
$ipv6PreferredLifeTime = "7.00:00:00"
$ipv6ValidLifeTime = "8.00:00:00"

$InternalIPNetwork = "192.168.130.128/26"

Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools
Add-DhcpServerV4Scope -Name $ipv4DHCPScopeName -StartRange $ipv4StartRange -EndRange $ipv4EndRange -SubnetMask $ipv4SubnetMask
Set-DhcpServerV4OptionValue -DnsServer $ipv4DNSServerIP -Router $ipv4DefaultGateway
Set-DhcpServerv4Scope -ScopeId $ipv4DHCPScopeID -LeaseDuration $ipv4LeaseDuration
Add-DhcpServerv6Scope -Name $ipv6DHCPScopeName -Prefix $ipv6Prefix -PreferredLifeTime $ipv6PreferredLifeTime -ValidLifeTime $ipv6ValidLifeTime
Restart-service dhcpserver
Install-WindowsFeature -name "NET-Framework-Features" –IncludeManagementTools
New-NetNat -Name "ClientNAT" -InternalIPInterfaceAddressPrefix $InternalIPNetwork
Install-WindowsFeature Print-Services -IncludeManagementTools
<#
Restart-Computer #run this line after the other things have finished
#>