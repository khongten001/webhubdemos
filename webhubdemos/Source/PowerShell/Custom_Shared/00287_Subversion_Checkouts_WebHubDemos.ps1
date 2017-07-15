# Subversion_Checkouts_WebHubDemos.ps1

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

$InfoMsg = '/note "About to download files using a series of subversion checkouts"'
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
Write-Output $InfoMsg

if ($Global:ZMGlobalContext -eq "DORIS") {
	Set-Location 'C:\'  # parent folder
	$svnurl = 'https://svn.code.sf.net/p/webhubdemos/code/trunk/webhubdemos/Servers/DB/drivecroot/whSwap'
	Start-Process $Global:CSConsole -ArgumentList $svnurl -NoNewWindow 
	Start-Process "svn.exe" -ArgumentList ("checkout " + $svnurl + " " + "c:\whSwap" + " --force ") -NoNewWindow -Wait
}


Set-Location 'D:\'  # parent folder
$svnurl = 'https://svn.code.sf.net/p/webhubdemos/code/trunk/webhubdemos/Servers/DB/drivedroot/ZaphodsMap'
Start-Process $Global:CSConsole -ArgumentList $svnurl -NoNewWindow 
Start-Process "svn.exe" -ArgumentList ("checkout " + $svnurl + " " + ".\ZaphodsMap" + " --force ") -NoNewWindow -Wait

Set-Location 'D:\'  # parent folder
$svnurl = 'https://svn.code.sf.net/p/webhubdemos/code/trunk/webhubdemos/Servers/DB/drivedroot/whAppliance'
Start-Process $Global:CSConsole -ArgumentList $svnurl -NoNewWindow 
Start-Process "svn.exe" -ArgumentList ("checkout " + $svnurl + " " + ".\whAppliance" + " --force ") -NoNewWindow -Wait


