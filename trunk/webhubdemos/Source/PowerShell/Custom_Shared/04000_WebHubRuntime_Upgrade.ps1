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
	New-Variable -Name use_cloudfront  -Value 'N' -Option private

	Start-Process $Global:CSConsole -ArgumentList '"Enter WebHub version to download"' -NoNewWindow 
	$webhub_version = read-host "Enter WebHub version to download: " 

	New-Variable -Name whrunsetup -Value ("WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -Option private
	New-Variable -Name filespec -Value ($Global:FolderInstallers + 'HREFTools\' + $whrunsetup) -Option private

	# delete any prior version from disk
	if (Test-Path $filespec) { Del $filespec }

	if ($Global:ZMGlobalContext -eq 'DORIS') {
		$use_cloudfront = 'Y'
		# The Setup binary 
		$source = "https://edeliver.href.com/WebHub/WebHub_Central/WebHub_X_Runtime_System_v3.260_Setup.exe?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9lZGVsaXZlci5ocmVmLmNvbS9XZWJIdWIvV2ViSHViX0NlbnRyYWwvV2ViSHViX1hfUnVudGltZV9TeXN0ZW1fdjMuMjYwX1NldHVwLmV4ZSIsIkNvbmRpdGlvbiI6eyJJcEFkZHJlc3MiOnsiQVdTOlNvdXJjZUlwIjoiNTIuOTAuODguMC8zMiJ9LCJEYXRlR3JlYXRlclRoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTQ2ODI2OTQwN30sIkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNDk5ODA1NzA3fX19XX0_&Signature=ZoGJ66cDu8ZTB~vBTUy2H9TpojtFzds1tnwzv3OyzwHyb69PlMNccs34CwzNorFnWVExvrGZ6Lj0h0BVb0UiKV0JcPZkw~JanbAq9HML-D2nsz9dC7niRsSHC8BruNB82RjPxsgUGO11UgkwGaiuMB5Alyz6SGMZM75OtLoUbdBVPwqnpFZOQLw7FmPub8u7XT2FmRzsIvXCTmX7~PItVsfozZpVG-e9txhz4ZdCC8AJe3oZ-7Oy86bOfsKPj2bF~BX6T-SPWIDf6ocDjcvJqetFimo3lSeyEWW9HgVzW~G10yuUcx4FSe9qLu0aAW5zt0CKeXJfLt2bFkuOzI4V4Q__&Key-Pair-Id=APKAIGAY3EJC77HVGRFQ"
		Start-Process $Global:CSConsole -ArgumentList ('Downloading ' + $whrunsetup ) -NoNewWindow -Wait
		Invoke-WebRequest $source -OutFile $filespec 
		if (! $?) { Start-Process $Global:CSConsole -ArgumentList ('/Error "Download Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait }
	}

	if ($Global:ZMGlobalContext -eq 'DEMOS') {
		$use_cloudfront = 'Y'
		# The Setup binary 
		$source = "https://edeliver.href.com/WebHub/WebHub_Central/WebHub_X_Runtime_System_v3.260_Setup.exe?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9lZGVsaXZlci5ocmVmLmNvbS9XZWJIdWIvV2ViSHViX0NlbnRyYWwvV2ViSHViX1hfUnVudGltZV9TeXN0ZW1fdjMuMjYwX1NldHVwLmV4ZSIsIkNvbmRpdGlvbiI6eyJJcEFkZHJlc3MiOnsiQVdTOlNvdXJjZUlwIjoiNTQuMTk3LjI1LjgzLzMyIn0sIkRhdGVHcmVhdGVyVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNDY4MjY5NDA4fSwiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE0OTk4MDU3MDh9fX1dfQ__&Signature=ZZMHo2LJbZf06OIkO0D8kJvjNBfUlVjG199Ze7fif9MVFKqhzJz9Rnepn-WOEYDZ1yQFmIFlZmCDAwGdYKa3QYnQtNmAMaInWkEcv0iw877-H2FG8uYEqOfxuCN9V9zslH4AzYylpv11enaCPCZxv8PH0g4RAj5tH2zweq8noO1zdUqX8v4oM3a95Bx4BzCGeIY0jp2f9YQbnjyiOoYbZU377vWSSzRu8ghR461UoeRGKokFiLtRBL9ew5uR7cmUhNBTQ0jtOvfy9T6-o2sVpeOVbLsNcHqMFEt-IUHDd0EsjuJtm-~QZFXnSGE3cBDFWRP6kYBdB6vzX2EF0v2sNw__&Key-Pair-Id=APKAIGAY3EJC77HVGRFQ"
		Start-Process $Global:CSConsole -ArgumentList ('Downloading ' + $whrunsetup ) -NoNewWindow -Wait
		Invoke-WebRequest $source -OutFile $filespec 
		if (! $?) { Start-Process $Global:CSConsole -ArgumentList ('/Error "Download Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait }
	}

	if ($use_cloudfront = 'N') {

		New-Variable -Name webhub_ftp_host -Value '' -Option private
		New-Variable -Name webhub_ftp_user -Value '' -Option private
		New-Variable -Name webhub_ftp_pass -Value '' -Option private

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
	Remove-Variable -Name use_cloudfront
}	

