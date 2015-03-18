# StreamCatcher via PowerShell
# Copyright 2014-2015 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# New StreamCatcher users should install by running SCSetup.exe
# This PowerShell script is intended only for users who already have configuration files.

# Please note that URLs will change when new releases occur.

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

$InfoMsg = '"Install StreamCatcher on D"'
echo $InfoMsg
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

$srcbase = "http://archiveinstallers.s3.amazonaws.com/win32"
$trgbase = "D:\Apps\HREFTools\StreamCatcher\Application"
if (!(Test-Path $trgbase)) {mkdir $trgbase}

DownloadHTTP ("http://www.streamcatcher.com/webrobotlist.txt") "D:\AppsData\StreamCatcher\Administrator\Config\webrobotlist.txt"
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-SCConsole-v1.9.0.5-win32-SCConsole.exe") ($trgbase + "\SCConsole.exe")
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-SCUserAgentScan-v1-win32-SCUserAgentScan.exe") ($trgbase + "\SCUserAgentScan.exe")
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-StreamCatcher.dll-v1.9.0.5-win32-StreamCatcher.dll") ($trgbase + "\StreamCatcher.dll")

# enable d:\Apps\HREFTools\StreamCatcher\Application\StreamCatcher.dll
# credit: http://learningpcs.blogspot.com.au/2011/08/powershell-iis-7-adding-isapi-filters.html
if (Test-Path ($trgbase + "\StreamCatcher.dll")) {
	# -AtIndex 2 for installation at a particular site level
	Add-WebConfiguration -filter /system.webServer/isapiFilters -PSPath "IIS:\sites"  -Value @{name="StreamCatcher 32bit ISAPI";path=($trgbase + "\StreamCatcher.dll")}
} else {
	Start-Process $Global:CSConsole -ArgumentList ('/error "StreamCatcher ISAPI filter NOT installed"') -NoNewWindow 
}

