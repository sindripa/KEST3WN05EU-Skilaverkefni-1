$computerName = "DC1"
$aPath = "c:\DnsServerConfig.xml"

Get-DnsServer -ComputerName $computerName | Export-Clixml -Path $aPath
$x = Import-Clixml $aPath
Set-DnsServer -InputObject $x -ComputerName $computerName
install-WindowsFeature -name "AD-Domain-Services" –IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest