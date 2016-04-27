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

	# Login credentials from a ZMKeyBox file.
	$webhub_ftp_host=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-host" "href.com" 2>&1
	$webhub_ftp_user=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-user" "user" 2>&1
	$webhub_ftp_pass=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-pass" "pass" 2>&1

	cls
	$whrunsetup = ("WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe")
	$InfoMsg = ('Downloading ' + $whrunsetup)
	echo $InfoMsg
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	$cmd = ("-u " + $webhub_ftp_user + " -p " + $webhub_ftp_pass + " " + $webhub_ftp_host + " . /" + $whrunsetup)
	$InfoMsg = '"ftp cmd" "' + $cmd + '"'
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	Start-Process "d:\Apps\Utilities\ncFTP\ncFTPGet.exe" -ArgumentList $cmd -NoNewWindow -Wait 

	$filespec = ($Global:FolderInstallers + 'HREFTools\' + $whrunsetup)
	if (! (Test-Path $filespec)) { 
		Start-Process $Global:CSConsole -ArgumentList ('/error ' + $filespec) -NoNewWindow 
		echo ERROR
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		Start-Process $Global:CSConsole -ArgumentList '"Continuing"' -NoNewWindow 
	}
	
	$InfoMsg = 'silent install of WebHub Runtime'
	echo $InfoMsg
	Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
	Start-Process ($Global:FolderInstallers + "HREFTools\WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -ArgumentList "/S /DIR=d:\Apps\HREFTools\WebHub" -NoNewWindow -Wait
	
	$InfoMsg = 'IISReset so that new ISAPI runner becomes active'
	echo $InfoMsg
	Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
	Start-Process "IISReset" -NoNewWindow -Wait

	$InfoMsg = ('/note "Done upgrading WebHubRuntime to ' + $webhub_version + '"')
	echo $InfoMsg
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

	Remove-Variable -Name webhub_version  
	Remove-Variable -Name webhub_ftp_host 
	Remove-Variable -Name webhub_ftp_user 
	Remove-Variable -Name webhub_ftp_pass 
}	

