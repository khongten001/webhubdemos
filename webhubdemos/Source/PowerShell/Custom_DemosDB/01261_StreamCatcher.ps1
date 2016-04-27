# StreamCatcher via PowerShell
# Copyright 2014-2016 HREF Tools Corp. 
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

# Import the WebAdministration module to allow access to IIS settings
Import-Module WebAdministration

New-Variable -Name SCVer    -Value "1.9.0.9" -Option private
New-Variable -Name SCDesc   -Value ("StreamCatcher 64-bit ISAPI v" + $SCVer) -Option private
New-Variable -Name SCFilter     -Option private

$InfoMsg = '"Install StreamCatcher on D"'
echo $InfoMsg
Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

$srcbase = "http://archiveinstallers.s3.amazonaws.com/win64"
$trgbase = "D:\Apps\HREFTools\StreamCatcher\Application"
if (!(Test-Path $trgbase)) {mkdir $trgbase}

DownloadHTTP ("http://www.streamcatcher.com/webrobotlist.txt") "D:\AppsData\StreamCatcher\Administrator\Config\webrobotlist.txt"
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-SCConsole-v" + $SCVer + "-win64-SCConsole.exe") ($trgbase + "\SCConsole.exe")
# stop IIS so that any existing DLL can be replaced.
Stop-Service w3svc
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-StreamCatcher.dll-v" + $SCVer + "-win64-StreamCatcher.dll") ($trgbase + "\StreamCatcher.dll")
Start-Service w3svc

$srcbase = "http://archiveinstallers.s3.amazonaws.com/win32"
DownloadHTTP ($srcbase + "/HREFTools-StreamCatcher-Application-SCUserAgentScan-v1-win32-SCUserAgentScan.exe") ($trgbase + "\SCUserAgentScan.exe")

# enable StreamCatcher.dll
# credit: http://learningpcs.blogspot.com.au/2011/08/powershell-iis-7-adding-isapi-filters.html
if (Test-Path ($trgbase + "\StreamCatcher.dll")) {
	$SCFilter = Get-WebConfiguration -filter /system.webServer/isapiFilters -PSPath "IIS:\sites"  -Location ($trgbase + "\StreamCatcher.dll")
	if ($SCFilter -ne $null) {
		# erase it first
		Clear-WebConfiguration -filter /system.webServer/isapiFilters -PSPath "IIS:\sites"  -Location ($trgbase + "\StreamCatcher.dll")
	}
	Add-WebConfiguration -filter /system.webServer/isapiFilters -PSPath "IIS:\sites"  -Value @{name=$SCDesc;path=($trgbase + "\StreamCatcher.dll")}
} else {
	Start-Process $Global:CSConsole -ArgumentList ('/error "StreamCatcher ISAPI filter NOT installed"') -NoNewWindow 
}

Remove-Variable SCVer
Remove-Variable SCDesc
Remove-Variable SCFilter
