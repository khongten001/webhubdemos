# Master copy is in the WebHubDemos svn repo
# webhubdemos\Source\PowerShell\Custom_Shared\04000_WebHubRuntime_Upgrade.ps1

# WebHubRuntime Upgrade
# Copyright 2014-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

<# Unlike the other powershell scripts, this one is meant to be used some 
   days, weeks or months AFTER the initial server build.  This upgrades 
   WebHub Runtime by downloading new files via ftp or from a private 
   CloudFront url, followed by running a silent install.

   FTP credentials are assumed to be stored in a ZMKeybox.xml file in 
   %ZaphodsMap%HREFTools\FileTransfer  under KeyGroup FTP.  

   CloudFront Access is restricted by IPv4.

   The latest WebHub release is defined here:
   https://www.href.com/whversion
#>

# call a separate script to init global variables.
Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"Upgrade WebHubRuntime" ' + $Global:FlagInstallWebHubRuntime)
Write-Output $InfoMsg
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

if ($Global:FlagInstallWebHubRuntime) {
	# prepare 
	Set-Location ($Global:FolderInstallers + 'HREFTools')

	New-Variable -Name webhub_version  -Value '' -Option private
	New-Variable -Name use_cloudfront  -Value 'N' -Option private

	if ($Global:ZMGlobalContext -eq 'DEMOS') {  # lite.demos.href.com
		$use_cloudfront = 'Y'
	}
	if ($Global:ZMGlobalContext -eq 'DORIS') {  # db.demos.href.com
		$use_cloudfront = 'Y'
	}
	if ($Global:ZMGlobalContext -eq 'NYX') { # delphi prefix registry 
		$use_cloudfront = 'Y'
	}


	if ($use_cloudfront -eq 'N') {
		Start-Process $Global:CSConsole -ArgumentList '"Enter WebHub version to download"' -NoNewWindow 
		$webhub_version = read-host "Enter WebHub version to download: " 
	}

	if ($use_cloudfront -eq 'Y') {
		New-Variable -Name response -Value "" -Option private
		New-Variable -Name postParams     -Value "" -Option private
		New-Variable -Name source   -Value "" -Option private
		$response = Invoke-RestMethod -Uri https://www.href.com/pub/relnotes/WebHub_Release_Status.json
		$webhub_version = $response.WebHubReleaseInfo.InHouse.v
		Start-Process $Global:CSConsole -ArgumentList ('/note "InHouse v' + $webhub_version + '"') -NoNewWindow -Wait
	}

	New-Variable -Name whrunsetup -Value ("WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -Option private
	New-Variable -Name filespec -Value ($Global:FolderInstallers + 'HREFTools\' + $whrunsetup) -Option private

	# delete any prior version from disk
	if (Test-Path $filespec) { Del $filespec }

	if ($use_cloudfront -eq 'Y') {
	
		if ($response.WebHubReleaseInfo.InHouse.status -eq 'c') {

			$postParams = @{whver=$webhub_version}
			$response = Invoke-RestMethod -Uri 'https://www.href.com/edeliver:ajaxWHRunTimeSetup' -Method POST -Body $postParams -ContentType "application/x-www-form-urlencoded"

			Start-Process $Global:CSConsole -ArgumentList ('/note "resource ' + $response.EDeliverResponse.Resource + '"') -NoNewWindow -Wait
	
			$source = $response.EDeliverResponse.URL
			if ($source -eq '') {
				Start-Process $Global:CSConsole -ArgumentList ('/error "response did not provide download/source url."') -NoNewWindow -Wait
				Start-Process $Global:CSConsole -ArgumentList ($response ) -NoNewWindow -Wait  # D:\whAppliance\whLogs
			} else {
	
				Start-Process $Global:CSConsole -ArgumentList ('/note "source url ' + $source + '"') -NoNewWindow -Wait
				Start-Process $Global:CSConsole -ArgumentList ('Downloading ' + $whrunsetup ) -NoNewWindow -Wait
				Invoke-WebRequest $source -OutFile $filespec 
				if (! $?) { Start-Process $Global:CSConsole -ArgumentList ('/Error "Download Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait }
			}
			Remove-Variable -Name response
			Remove-Variable -Name postParams
			Remove-Variable -Name source
		} else {

			Start-Process $Global:CSConsole -ArgumentList ('/note "See https://www.href.com/pub/relnotes/WebHub_Release_Status.json"') -NoNewWindow -Wait
			Start-Process $Global:CSConsole -ArgumentList ('/warning "WebHub Runtime Setup is not currently ready for download."') -NoNewWindow -Wait
		}
	}

	if ($use_cloudfront -eq 'N') {

		New-Variable -Name webhub_ftp_host -Value '' -Option private
		New-Variable -Name webhub_ftp_user -Value '' -Option private
		New-Variable -Name webhub_ftp_pass -Value '' -Option private

		# Login credentials from a ZMKeyBox file.
		$webhub_ftp_host=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-host" "href.com" 2>&1
		$webhub_ftp_user=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-user" "user" 2>&1
		$webhub_ftp_pass=&($env:ZaphodsMap + 'ZMLookup.exe') /Key2Value "HREFTools\FileTransfer" FTP "webhubcom-pass" "pass" 2>&1
	
		cls
	
		$InfoMsg = ('Downloading ' + $whrunsetup)
		Write-Output $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

		#ncFtpGet
		#http://www.ncftp.com/ncftp/doc/ncftpget.html
		#-F
		#    Use passive (PASV) data connections.  The default is to use passive, but to fallback to regular if the passive connection fails or times out. 

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
		Write-Output ERROR
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		Start-Process $Global:CSConsole -ArgumentList '"Continuing"' -NoNewWindow 
	} else {
	
		$InfoMsg = 'silent install of WebHub Runtime'
		Write-Output $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
		Start-Process ($Global:FolderInstallers + "HREFTools\WebHub_X_Runtime_System_v" + $webhub_version + "_Setup.exe") -ArgumentList "/S /DIR=d:\Apps\HREFTools\WebHub" -NoNewWindow -Wait
	
		$InfoMsg = 'clone win64 runner DLL'
		Write-Output $InfoMsg
		Stop-Service w3svc
		Copy D:\Apps\HREFTools\WebHub\bin\whRunner\runisa64.dll D:\Apps\HREFTools\WebHub\bin\whRunner\runisa.dll 
		
		$InfoMsg = 'IISReset so that new ISAPI runner becomes active'
		Write-Output $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList ('"' + $InfoMsg + '"') -NoNewWindow 
		Start-Process "IISReset" -NoNewWindow -Wait
	
		$InfoMsg = ('/note "Done upgrading WebHubRuntime to ' + $webhub_version + '"')
		Write-Output $InfoMsg
		Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	}

	Remove-Variable -Name webhub_version  
	Remove-Variable -Name whrunsetup
	Remove-Variable -Name filespec
	Remove-Variable -Name use_cloudfront
}	

