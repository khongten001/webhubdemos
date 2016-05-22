# Delphi Redist files for WebHubDemos
# Copyright 2014-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + "\Initialize.ps1")

$InfoMsg = ('/note "Delphi Redist Files for WebHubDemos"')
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

# 64-bit files

	$source = "https://archiveinstallers.s3.amazonaws.com/win64/D24_redist_win64.7z"
	$destination = ($Global:FolderInstallers + "D24_redist_win64.7z")

	$InfoMsg = ('Downloading ' + $source)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg
	Invoke-WebRequest $source -OutFile $destination
	if (! $?) { 
		Start-Process $Global:CSConsole -ArgumentList ('/Error "Download D24_redist_win64.7z; Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait 
	} 

	$InfoMsg = ('Unzipping ' + $destination)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg

	Set-Location "D:\Projects\WebHubDemos\Live\Library64"
	Start-Process "d:\Apps\Utilities\7Zip\7z.exe" -ArgumentList ("x " + $destination) -NoNewWindow -Wait
	ls "D:\Projects\WebHubDemos\Live\Library64\vcl*.bpl"

	$source = "http://data.rubicon.href.com/FirebirdSQL_Client/fbclient_win64.dll"
	$destination = "D:\Projects\WebHubDemos\Live\Library64\fbclient_win64.dll"
	$InfoMsg = ('Downloading ' + $source)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg
	Invoke-WebRequest $source -OutFile $destination
	if (! $?) { 
		Start-Process $Global:CSConsole -ArgumentList ('/Error "Download fbclient_win64.dll; Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait 
	}



# 32-bit files

	$source = "http://archiveinstallers.s3.amazonaws.com/win32/D22_redist_upd1_win32.7z"
	$destination = ($Global:FolderInstallers + "D22_redist_upd1_win32.7z")

	$InfoMsg = ('Downloading ' + $source)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg
	Invoke-WebRequest $source -OutFile $destination
	if (! $?) { 
		Start-Process $Global:CSConsole -ArgumentList ('/Error "Download D22_redist_upd1_win32.7z; Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait 
	} 

	$InfoMsg = ('Unzipping ' + $destination)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg

	Set-Location "D:\Projects\WebHubDemos\Live\Library"
	Start-Process "d:\Apps\Utilities\7Zip\7z.exe" -ArgumentList ("x " + $destination) -NoNewWindow -Wait
	ls "D:\Projects\WebHubDemos\Live\Library\vcl*.bpl"

	$source = "http://data.rubicon.href.com/FirebirdSQL_Client/fbclient_win32.dll"
	$destination = "D:\Projects\WebHubDemos\Live\Library\fbclient_win32.dll"
	$InfoMsg = ('Downloading ' + $source)
	Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
	echo $InfoMsg
	Invoke-WebRequest $source -OutFile $destination
	if (! $?) { 
		Start-Process $Global:CSConsole -ArgumentList ('/Error "Download fbclient_win32.dll; Exit code ' + $LastExitCode.ToString + '"')  -NoNewWindow -Wait 
	} 
	else {
		Copy "D:\Projects\WebHubDemos\Live\Library\fbclient_win32.dll" "D:\Projects\WebHubDemos\Live\Library\fbclient.dll"
	}

