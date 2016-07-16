# Master copy is in the WebHubDemos svn repo

# WebHubRuntime Upgrade
# Copyright 2014-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

<# Unlike the other powershell scripts, this one is meant to be used some 
   days, weeks or months AFTER the initial server build.  This upgrades 
   WebHub Runtime by downloading new files from a private CloudFront url
   and then running a silent install.

   Access is restricted by IPv4.
#>

# call a separate script to init global variables.
Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"Upgrade WebHubRuntime" ' + $Global:FlagInstallWebHubRuntime)
echo $InfoMsg
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

if ($Global:FlagInstallWebHubRuntime) {
	# prepare 
	Set-Location ($Global:FolderInstallers + 'HREFTools')

	New-Variable -Name webhub_version  -Value '' -Option private
	New-Variable -Name use_cloudfront  -Value 'N' -Option private

	#Start-Process $Global:CSConsole -ArgumentList '"Enter WebHub version to download"' -NoNewWindow 
	#$webhub_version = read-host "Enter WebHub version to download: " 

	if ($Global:ZMGlobalContext -eq 'DORIS') {
		$use_cloudfront = 'Y'
	}

	if ($use_cloudfront -eq 'Y') {
		New-Variable -Name response -Value "" -Option private
		New-Variable -Name postParams     -Value "" -Option private
		New-Variable -Name source   -Value "" -Option private
		$response = Invoke-RestMethod -Uri https://www.href.com/pub/relnotes/WebHub_Release_Status.json
		$webhub_version = $response.WebHubReleaseInfo.InHouse.v
		Start-Process $Global:CSConsole -ArgumentList ('/note "InHouse v' + $webhub_version + '"') -NoNewWindow -Wait

		New-Variable -Name whrunsetup -Value ("WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -Option private
		New-Variable -Name filespec -Value ($Global:FolderInstallers + 'HREFTools\' + $whrunsetup) -Option private
	
		# delete any prior version from disk
		if (Test-Path $filespec) { Del $filespec }

		$postParams = @{whver=$webhub_version}
		$response = Invoke-RestMethod -Uri 'https://www.href.com/edeliver:ajaxWHRunTimeSetup' -Method POST -Body $postParams -ContentType "application/x-www-form-urlencoded"
		#Start-Process $Global:CSConsole -ArgumentList ($response ) -NoNewWindow -Wait

		Start-Process $Global:CSConsole -ArgumentList ('/note "resource ' + $response.EDeliverResponse.Resource + '"') -NoNewWindow -Wait

		$source = $response.EDeliverResponse.URL

		Start-Process $Global:CSConsole -ArgumentList ('/note "source url ' + $source + '"') -NoNewWindow -Wait
		Start-Process $Global:CSConsole -ArgumentList ('Downloading ' + $whrunsetup ) -NoNewWindow -Wait
		Invoke-WebRequest $source -OutFile $filespec 
		if (! $?) { Start-Process $Global:CSConsole -ArgumentList ('/Error "Download Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait }
		Remove-Variable -Name response
		Remove-Variable -Name postParams
		Remove-Variable -Name source
	}

	if (! (Test-Path $filespec)) { 
		Start-Process $Global:CSConsole -ArgumentList ('/error ' + $filespec) -NoNewWindow 
		echo ERROR
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		Start-Process $Global:CSConsole -ArgumentList '"Continuing"' -NoNewWindow 
	} else {
	
		$InfoMsg = 'silent install of WebHub Runtime'
		echo $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
		Start-Process ($Global:FolderInstallers + "HREFTools\WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -ArgumentList "/S /DIR=d:\Apps\HREFTools\WebHub" -NoNewWindow -Wait
	
		$InfoMsg = 'clone win64 runner DLL'
		echo $InfoMsg
		Stop-Service w3svc
		Copy D:\Apps\HREFTools\WebHub\bin\whRunner\runisa64.dll D:\Apps\HREFTools\WebHub\bin\whRunner\runisa.dll 
		
		$InfoMsg = 'IISReset so that new ISAPI runner becomes active'
		echo $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
		Start-Process "IISReset" -NoNewWindow -Wait
	
		$InfoMsg = ('/note "Done upgrading WebHubRuntime to ' + $webhub_version + '"')
		echo $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	}

	Remove-Variable -Name webhub_version  
	Remove-Variable -Name whrunsetup
	Remove-Variable -Name filespec
	Remove-Variable -Name use_cloudfront
}	

