$computerName = "Client1"
$localCredential = "Admin"
$domainName = "sindri.local"
$domainCredential = "administrator"+"@"+$domainName

Add-Computer -ComputerName $computerName -LocalCredential $localCredential -DomainName $domainName -Credential $domainCredential -PassThru -Restart -Force