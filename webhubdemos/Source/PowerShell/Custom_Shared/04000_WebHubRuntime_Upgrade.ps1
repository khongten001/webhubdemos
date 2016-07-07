# Master copy is in the WebHubDemos svn repo
# webhubdemos\Source\PowerShell\Custom_Shared\04000_WebHubRuntime_Upgrade.ps1

# WebHubRuntime Upgrade
# Copyright 2014-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

<# Unlike the other powershell scripts, this one is meant to be used some 
   days, weeks or months AFTER the initial server build.  This upgrades 
   WebHub Runtime by downloading new files via ftp and then running a 
   silent install.

   FTP credentials are assumed to be stored in a ZMKeybox.xml file in 
   %ZaphodsMap%HREFTools\FileTransfer  under KeyGroup FTP.  

   The latest WebHub release is defined here:
   https://www.href.com/whversion
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
	New-Variable -Name webhub_ftp_host -Value '' -Option private
	New-Variable -Name webhub_ftp_user -Value '' -Option private
	New-Variable -Name webhub_ftp_pass -Value '' -Option private

	Start-Process $Global:CSConsole -ArgumentList '"Enter WebHub version to download"' -NoNewWindow 
	$webhub_version = read-host "Enter WebHub version to download: " 

	New-Variable -Name whrunsetup -Value ("WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -Option private
	New-Variable -Name filespec -Value ($Global:FolderInstallers + 'HREFTools\' + $whrunsetup) -Option private

	# delete any prior version from disk
	if (Test-Path $filespec) { Del $filespec }

	if ($Global:ZMGlobalContext -eq 'DORIS') {
	
		# The Setup binary 
		$source = "http://edeliver.href.com/WebHub/WebHub_Central/WebHub_X_Runtime_System_v3.259_Setup.exe?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cCo6Ly9lZGVsaXZlci5ocmVmLmNvbS8qIiwiQ29uZGl0aW9uIjp7IklwQWRkcmVzcyI6eyJBV1M6U291cmNlSXAiOiI1Mi45MC44OC4wLzMyIn0sIkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNTk0NzY5OTEwfX19XX0_&Signature=qrLQntRVJoVTwvGpNFB9MhNBwPhm9UgZg~eplWr9szTR0wn2AFMArWwWItY9ILUqpaFtWTQGazqp8atPE3onBRp08mBNAKFXruh~owowp8nmk3rAaMSM0-DRVgrdXTCyqzOjgXwsUnmTYjoz-d08bGQ5k6KAWzwLuaSW-nvS92gbCQ4ZmNosnv2unXtgquzZ3xjGu-vfmzJ3nlMhDQlqB~Axt5UCsL6dTDneOWoUcTOuMSgdAbqxCimH6HmJNdEz8j5oCRlPf1GIju33L8VRUbzCO5IXHjji7K1tinZb64WnK3d6e6OP0NgwR52IoEkprNncODEy5qb9QZYv8ZyEbw__&Key-Pair-Id=APKAIAWNF4CKNMTJRMVA"
		Start-Process $Global:CSConsole -ArgumentList ('Downloading ' + $whrunsetup ) -NoNewWindow -Wait
		$destination = ($NcfPath + "\ncftp.exe")
		Invoke-WebRequest $source -OutFile $filespec 
		if (! $?) { Start-Process $Global:CSConsole -ArgumentList ('/Error "Download ncftp.exe; Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait }
	}
	else {

		# Login credentials from a ZMKeyBox file.
		$webhub_ftp_host=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-host" "href.com" 2>&1
		$webhub_ftp_user=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-user" "user" 2>&1
		$webhub_ftp_pass=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-pass" "pass" 2>&1
	
		cls
	
		$InfoMsg = ('Downloading ' + $whrunsetup)
		echo $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
		$cmd = ("-u " + $webhub_ftp_user + " -p " + $webhub_ftp_pass + " " + $webhub_ftp_host + " . /" + $whrunsetup)
		$InfoMsg = '"ftp cmd" "' + $cmd + '"'
		Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
		Start-Process "d:\Apps\Utilities\ncFTP\ncFTPGet.exe" -ArgumentList $cmd -NoNewWindow -Wait 
	
		Remove-Variable -Name webhub_ftp_host 
		Remove-Variable -Name webhub_ftp_user 
		Remove-Variable -Name webhub_ftp_pass 
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
}	

