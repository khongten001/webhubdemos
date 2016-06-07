# URL2FILE utility, downlaod via PowerShell
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

function DownloadHTTP($source, $destination) {
	Start-Process $Global:CSConsole -ArgumentList ('Downloading "' + $source + '"') -NoNewWindow -Wait
	Start-Process $Global:CSConsole -ArgumentList ('Destination "' + $destination + '"') -NoNewWindow -Wait
	Invoke-WebRequest $source -OutFile $destination
	if (! (Test-Path $destination)) {
		Start-Process $Global:CSConsole -ArgumentList ('/error "Not downloaded: "' + $destination + '"') -NoNewWindow -Wait
	}
}

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

$InfoMsg = '"Install URL2File Utility"'
echo $InfoMsg
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

$trgbase = "D:\Apps\Utilities\Url2File"
if (!(Test-Path $trgbase)) {mkdir $trgbase}

DownloadHTTP ("https://archiveinstallers.s3.amazonaws.com/win32/Utilities-Url2File-v1.981208-32bit-URL2FILE.EXE") ($trgbase + "\URL2FILE.EXE")
