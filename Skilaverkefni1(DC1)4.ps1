Import-Module activedirectory
$CSVpath                   = "C:\csv.csv"
$ADUsers                   = Import-csv $CSVpath
#$typepasswordhere          = "" #you can type a set password if you do not want to be prompted
$typepasswordhere          = Read-Host -Prompt "Type Base Password here"
$domain                    = "sindri.local"
$supervisor                = "HarHja"
$DC                        = 'DC=sindri,DC=local'
$company                   = 'company'
$domain2                   = 'OU='+$company+','+$DC
$preDC                     = 'OU='
$domain3                   = ','+$domain2
$groupArray                = "IT","Management","Harpa","Engineering","Finance","Manufacturing"
$employeeShare             = "EmployeeShare"
$chosenDir                 = "c:\"
$employeeShareDir          = $chosenDir + $employeeShare
$sharedShare               = "SharedShare"
$administrator             = $domain + "\administrator"
$sharedShareDir            = $employeeShareDir + "\" + $sharedShare
$printDriverName           = "Microsoft Print To PDF"
$printerHostAddressBase    = "192.168.130.16"
$printerHostAddressCounter = 0
$sharedPrintPortName       = "SharedPrintPort"
$sharedPrinterName         = "SharedPrinter"

#OU creation
if (Get-ADOrganizationalUnit -F {Name -eq $company})
{
    Write-Warning "An OU with the name $company already exist in Active Directory."
}
else
{
    New-ADOrganizationalUnit -Name $company -Path $DC
}

foreach ($group in $groupArray)
{
    $domainGroup = $preOU+$group+$domain3

    if (Get-ADOrganizationalUnit -F {Name -eq $group})
	{
		 Write-Warning "An OU with the name $group already exist in Active Directory."
	}
    else
    {
        New-ADOrganizationalUnit -Name $group -Path $domain2
    }

    #Group creation
    if (Get-ADGroup -F {SamAccountName -eq $group})
	{
		 Write-Warning "A group with the name $group already exist in Active Directory."
	}
    else
    {
        New-ADGroup -Name $group -SamAccountName $group -GroupCategory Security -GroupScope Universal -DisplayName $group -Path $domainGroup
    }
}

#User creation
foreach ($User in $ADUsers)
{
    $fullname      = $User.fullname
    $userprinciple = $User.userprinciple + "@" + $domain
	$Username 	   = $User.userprinciple
	$Firstname     = $User."first name"
	$Lastname 	   = $User."last name"
    $email         = $User.email
    $department    = $User.dept
    $OU            = $preDC+$department+','+$domain2
    $Password      = $typepasswordhere
    $CN            = 'CN='+$department+','+$OU

	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
    elseif ($Username -eq $supervisor)
    {
        New-ADUser -SamAccountName $Username -UserPrincipalName $userprinciple -Name $fullname -GivenName $Firstname -Surname $Lastname -Enabled $True -DisplayName $fullname -Path $OU -EmailAddress $email -Department $department -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
    }
	else
	{
        New-ADUser -SamAccountName $Username -UserPrincipalName $userprinciple -Name $fullname -GivenName $Firstname -Surname $Lastname -Enabled $True -DisplayName $fullname -Path $OU -EmailAddress $email -Department $department -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True -Manager $supervisor
	}
    Add-ADGroupMember -Identity $CN -Members $Username
}

#SharedFolder creation
if (Test-Path $employeeShareDir -PathType Container)
{
    Write-Warning "A directory with the name $employeeShare already exist in Active Directory."
}
else
{
    New-Item -Path $chosenDir -Name $employeeShare -ItemType "directory"
}
if (Test-Path $sharedShareDir -PathType Container)
{
    Write-Warning "A directory with the name $sharedShare already exist in Active Directory."
}
else
{
    New-Item -Path $employeeShareDir -Name $sharedShare -ItemType "directory"
}
if (!(!(Get-SmbShare -Name $sharedShare)))
{
    Write-Warning "A SmbShare with the name $sharedShare already exist in Active Directory."
}
else
{
    New-SmbShare -Path $employeeShareDir -Name $sharedShare -FullAccess everyone
}

foreach ($group in $groupArray)
{
    $sharedGroup    = "Shared" + $group
    $sharedGroupDir = $employeeShareDir + "\" + $group
    if (Test-Path $sharedGroupDir -PathType Container)
    {
        Write-Warning "A directory with the name $group already exist in Active Directory."
    }
    else
    {
        New-Item -Path $employeeShareDir -Name $group -ItemType "directory"
    }
    if (!(!(Get-SmbShare -Name $sharedGroup)))
    {
        Write-Warning "A SmbShare with the name $sharedGroup already exist in Active Directory."
    }
    else
    {
        New-SmbShare -Name $sharedGroup -Path $sharedGroupDir  -FullAccess $administrator
    }
}

#Printer creation
if (!(!(Get-PrinterDriver -Name $printDriverName)))
{
    Write-Warning "A printerDriver with the name $printDriverName already exist in Active Directory."
}
else
{
    Add-PrinterDriver -Name  $printDriverName
}

foreach ($group in $groupArray)
{
    $printerHostAddress        = $printerHostAddressBase + $printerHostAddressCounter
    $printerHostAddressCounter = $printerHostAddressCounter + 1
    $printerPortName           = $group + "PrintPort"
    $printerName               = $group + "Printer"

    if (!(!(Get-PrinterPort -Name $printerPortName)))
    {
        Write-Warning "A printerPort with the name $printerPortName already exist in Active Directory."
    }
    else
    {
        Add-PrinterPort -Name $printerPortName -PrinterHostAddress $printerHostAddress
    }
    if (!(!(Get-Printer -Name $printerName)))
    {
        Write-Warning "A printer with the name $printerName already exist in Active Directory."
    }
    else
    {
        Add-Printer -Name $printerName -DriverName $printDriverName -PortName $printerPortName
    }
}

$sharedPrinterHostAddress = $printerHostAddressBase + $printerHostAddressCounter

if (!(!(Get-PrinterPort -Name $sharedPrintPortName)))
{
    Write-Warning "A printerPort with the name $sharedPrintPortName already exist in Active Directory."
}
else
{
    Add-PrinterPort -Name $sharedPrintPortName -PrinterHostAddress $sharedPrinterHostAddress
}
if (!(!(Get-Printer -Name $sharedPrinterName)))
{
    Write-Warning "A printer with the name $sharedPrinterName already exist in Active Directory."
}
else
{
    Add-Printer -Name $sharedPrinterName -DriverName $printDriverName -PortName $sharedPrintPortName
}