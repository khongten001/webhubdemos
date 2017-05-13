# StreamCatcher WebRobotList via PowerShell
# Copyright 2014-2017 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# New StreamCatcher users should install by running SCSetup.exe
# This PowerShell script is intended only for users who already have configuration files.

# Optional: run this as a daily scheduled task to obtain the latest WebRobotList regularly

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

New-Variable -Name TempFilespec -Value ($Global:FolderInstallers + 'HREFTools\webrobotlist.txt') -Option private

DownloadHTTP ("http://www.streamcatcher.com/webrobotlist.txt") $TempFilespec

if (Test-Path D:\AppsData\StreamCatcher\Administrator\config) {
	Copy $TempFilespec D:\AppsData\StreamCatcher\Administrator\config\webrobotlist.txt
}

if (Test-Path D:\whAppliance\streamcatcher\Administrator\Config) {
	Copy $TempFilespec D:\whAppliance\streamcatcher\Administrator\Config\webrobotlist.txt
}

if (Test-Path D:\whAppliance\scConfig) {
	Copy $TempFilespec D:\whAppliance\scConfig\webrobotlist.txt
}

# erase temporary copy
Del $TempFilespec

Start-Process 'iisreset' -NoNewWindow -Wait


Remove-Variable TempFilespec