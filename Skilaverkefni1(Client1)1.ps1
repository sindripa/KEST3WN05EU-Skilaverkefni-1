$newComputerName = "Client1"
$netAdapterName = "Ethernet0"
$newNetAdapterName = "Private"

Rename-Computer -NewName $newComputerName
Rename-NetAdapter -Name $netAdapterName -NewName $newNetAdapterName
<#
Restart-Computer #run this line after the other things have finished
#>