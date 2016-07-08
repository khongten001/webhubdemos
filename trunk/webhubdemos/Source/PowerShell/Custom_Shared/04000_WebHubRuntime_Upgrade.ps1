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
		$source = "http://edeliver.href.com/WebHub/WebHub_Central/WebHub_X_Runtime_System_v3.259_Setup.exe?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cCo6Ly9lZGVsaXZlci5ocmVmLmNvbS9XZWJIdWIvKiIsIkNvbmRpdGlvbiI6eyJJcEFkZHJlc3MiOnsiQVdTOlNvdXJjZUlwIjoiNTIuOTAuODguMC8zMiJ9LCJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU4NTcwMjkyM319fV19&Signature=s6JTUeGNRz01IJ1jSkDogU5uIEOb2U7j7ClxnIlnADi5mbH6bdKCmkb56XFALSzpLbSws3laijXFyN9smTd3Fy0LUl4AZqg98QQDXU8gAdCEyULfWuF0uIZ7S7~EMTvRACi57z-2wPoFJKpVnKB1pybi1DnskCauQyWJqoIqljvqEcUuvvwyVyclNToRaXAZB0M2~Wdj7g5mDr5Yih0hUdAPx6Nsp8BXtFI0xBELV3RqjUHp3mjsbQRWyCXG5vcEd-6aZ-pw-0cCEKr7Pd2tXO2jDjbwObuO7kYoEhHQH15rhZn~JTOR1M2v~gOKHqFiRo74Md2RcD21cTsbSbWFsA__&Key-Pair-Id=APKAIGAY3EJC77HVGRFQ"
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

