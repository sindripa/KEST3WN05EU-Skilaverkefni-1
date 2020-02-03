$gpopath = "C:\GPOs"
$employeeOU = "ou=company,dc=sindri,dc=local"
$ITOU = "ou=IT," + $employeeOU
$ManagementOU = "ou=Management," + $employeeOU
$EngineeringOU = "ou=Engineering," + $employeeOU
$HarpaOU = "ou=Harpa," + $employeeOU
$FinanceOU = "ou=Finance," + $employeeOU
$ManufacturingOU = "ou=Manufacturing," + $employeeOU
$Fold = $gpopath + "\set screen save"
$BackID = "{A11ED179-A62E-427E-BEED-18219EBC5F3B}"
$GPOName = "set screen save"

New-GPO -Name $GPOName
Import-GPO -path $Fold -BackupId $BackID -TargetName $GPOName
New-GPLink -Name $GPOName -Target $ITOU -LinkEnabled Yes
New-GPLink -Name $GPOName -Target $ManagementOU -LinkEnabled Yes
New-GPLink -Name $GPOName -Target $HarpaOU -LinkEnabled Yes
New-GPLink -Name $GPOName -Target $FinanceOU -LinkEnabled Yes
New-GPLink -Name $GPOName -Target $ManufacturingOU -LinkEnabled Yes



$MapGPONameArray = "map Engineering share", "map Finance share", "map Harpa share", "map IT share", "map Management share", "map Manufacturing share"
$MapGPOIDArray = "{A8FA853C-085B-4238-8C19-371AD4199999}", "{793C3611-75D0-4EBF-B594-851591325FFF}", "{9A2BDCEC-346F-431E-BFF7-3FAB33826113}", "{2BFEB8E7-BB59-4D11-8349-45C222EA69A4}", "{BAAC016F-9B45-41EA-9696-1683D1FAA726}", "{B0B8CC43-526F-4829-ACA8-CC246797C36A}"


$OUNameArray = $EngineeringOU, $FinanceOU, $HarpaOU, $ITOU, $ManagementOU, $ManufacturingOU

$MapGPONameArray = "map Engineering share", "map Finance share", "map Harpa share", "map IT share", "map Management share", "map Manufacturing share"
$MapGPOIDArray = "{A8FA853C-085B-4238-8C19-371AD4199999}", "{793C3611-75D0-4EBF-B594-851591325FFF}", "{9A2BDCEC-346F-431E-BFF7-3FAB33826113}", "{2BFEB8E7-BB59-4D11-8349-45C222EA69A4}", "{BAAC016F-9B45-41EA-9696-1683D1FAA726}", "{B0B8CC43-526F-4829-ACA8-CC246797C36A}"


For ($i=0; $i -lt $MapGPONameArray.Length; $i++){

    $Fold = $gpopath + "\" + $MapGPONameArray[$i]
	
	New-GPO -Name $MapGPONameArray[$i]
    
    Import-GPO -Path $Fold -BackupId $MapGPOIDArray[$i] -TargetName $MapGPONameArray[$i]

    New-GPLink -Name $MapGPONameArray[$i] -Target $OUNameArray[$i]

}

$Fold = $gpopath + "\map Share share"
New-GPO -Name "map Share share"
Import-GPO -Path $Fold -BackupId "{E008D14F-2CA9-4203-A356-0BA14240E53E}" -TargetName "map Share share"
New-GPLink -Name "map Share share" -Target $employeeOU


$Fold = $gpopath + "\restrict taskmgr and control"
New-GPO -Name "restrict taskmgr and control"
Import-GPO -Path $Fold -BackupId "{1A9DB1F6-C0C2-42B5-BE9A-6CA06D6A9EBB}" -TargetName "map Share share"

New-GPLink -Name "map Share share" -Target $EngineeringOU
New-GPLink -Name "map Share share" -Target $FinanceOU
New-GPLink -Name "map Share share" -Target $HarpaOU
New-GPLink -Name "map Share share" -Target $ITOU
New-GPLink -Name "map Share share" -Target $ManufacturingOU



New-SmbShare -Name autoInstall -Path "c:\auto install"  -FullAccess sindri.local\administrator

$Fold = $gpopath + "\install firefox"
New-GPO -Name "install firefox"
Import-GPO -Path $Fold -BackupId "{F7326C9E-ABEB-4DCD-9106-FFE094A778EE}" -TargetName "install firefox"

New-GPLink -Name "install firefox" -Target $employeeOU


$Fold = $gpopath + "\no firefox"
New-GPO -Name "no firefox"
Import-GPO -Path $Fold -BackupId "{752DFEFE-EA8E-49EA-A0A9-A7D098D0F42D}" -TargetName "no firefox"

New-GPLink -Name "no firefox" -Target $ManufacturingOU



$printGPONameArray = "share Engineering printer", "share Finance printer", "share Harpa printer", "share IT printer", "share Management printer", "share Manufacturing printer"
$printGPOBackID = "{7DA21A69-25A3-4DDD-B9DB-D96065AFA07C}", "{AB64D675-877D-4FA4-848C-BEEBA269876C}", "{C0CB0D26-81E2-4BDC-86EC-6FAF31448213}", "{5BCEF547-3A5A-4FA7-8055-81F675DB259B}", "{E4FB64EA-B311-42B0-B289-5E33C16E5A3D}", "{D8BCE15C-DA47-4A5A-B6B2-EBC5F5E0A01B}"


For ($i=0; $i -lt $printGPONameArray.Length; $i++){

    $Fold = $gpopath + "\" + $printGPONameArray[$i]
	
	New-GPO -Name $printGPONameArray[$i]
    
    Import-GPO -Path $Fold -BackupId $printGPOBackID[$i] -TargetName $printGPONameArray[$i]

    New-GPLink -Name $printGPONameArray[$i] -Target $OUNameArray[$i]

}


$Fold = $gpopath + "\share Share printer"
New-GPO -Name "share Share printer"
Import-GPO -Path $Fold -BackupId "{4721A0FB-2ED8-4D34-B839-895271DBD34A}" -TargetName "share Share printer"
New-GPLink -Name "share Share printer" -Target $employeeOU