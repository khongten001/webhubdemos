

<# ************************** #>
<# run these manually by copy+paste into the powershell console on the target machine over remote desktop #>
$Trg = "C:\Temp\PowerShell\Custom"
if (!(Test-Path $Trg)) { MKDIR $Trg }
if (!(Test-Path "$Trg\.svn")) {
	Set-Location 'C:\'  # parent folder
	$svnurl = 'https://svn.code.sf.net/p/webhubdemos/code/trunk/webhubdemos/Source/PowerShell/Custom_DemosDB'
	Start-Process "svn.exe" -ArgumentList ("checkout " + $svnurl + " " + $Trg + " --username hreftechsupport --force ") -NoNewWindow -Wait
} else {
	Set-Location $Trg
	Start-Process "svn.exe" -ArgumentList "update"  -NoNewWindow -Wait
}

$Trg = "C:\Temp\PowerShell\Custom_Shared"
if (!(Test-Path $Trg)) { MKDIR $Trg }
if (!(Test-Path "$Trg\.svn")) {
	Set-Location 'C:\'  # parent folder
	$svnurl = 'https://svn.code.sf.net/p/webhubdemos/code/trunk/webhubdemos/Source/PowerShell/Custom_Shared'
	Start-Process "svn.exe" -ArgumentList ("checkout " + $svnurl + " " + $Trg + " --force ") -NoNewWindow -Wait
} else {
	Set-Location $Trg
	Start-Process "svn.exe" -ArgumentList "update"  -NoNewWindow -Wait
}

$svnurl = 'https://svn.riouxsvn.com/psmiscwebhub/trunk/Custom_StreamCatcher'
Start-Process "svn.exe" -ArgumentList ("export " + $svnurl + " " + "C:\Temp\PowerShell\Custom" + " --force ") -NoNewWindow -Wait

$svnurl = 'https://svn.riouxsvn.com/psmiscwebhub/trunk/Custom_PurgeByDate'
Start-Process "svn.exe" -ArgumentList ("export " + $svnurl + " " + "C:\Temp\PowerShell\Custom" + " --force ") -NoNewWindow -Wait

Remove-Variable -Name Trg
Remove-Variable -Name svnurl

Set-Location "C:\Temp\PowerShell\Custom"
DIR 

<# ************************** #>

