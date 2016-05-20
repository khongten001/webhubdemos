# Master copy is in the WebHubDemos svn repo
# webhubdemos\Source\PowerShell\Custom_Shared\01133_IIS_Custom_Errors.ps1

# Configure several custom error responses within Microsoft IIS, e.g. for 500.12 and 500.13 errors
# Copyright 2015-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# Thanks to http://forums.iis.net/t/1185503.aspx?creating+a+custom+http+error+for+single+site+in+powershell
# Thanks to Joshua Gong for ideas and syntax for the PrepareEnableCustomErrors function and its usage.

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

# Alert! Using Response-Mode FILE rather than URL is necessary if you want the status code and headers to arrive at the http client


# First, make latest version of shared functions available
Import-Module WebAdministration

if (! (Test-Path ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup'))) { 
	mkdir ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup')
}
copy ($PSScriptRoot + '\..\WebHub_Appliance_PS\Mod_IIS_Setup.psm1')   $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup\Mod_IIS_Setup.psm1
Import-Module Mod_IIS_Setup

New-Variable -Name ErrorFilePath -Value "D:\Projects\webhubdemos\Live\WebHub\whmsg\" -Option private

# Enable then configure custom errors for a web site
New-Variable -Name AWebSiteName  -Value "WebHub Lite Demos" -Option private
New-Variable -Name SiteExists -Value ( (Get-WebSite $AWebSiteName -ErrorAction SilentlyContinue) -ne $null )  -Option private
if ($SiteExists) {
	# should exist on lite.demos.href.com server
	PrepareEnableCustomErrors $AWebSiteName        ($ErrorFilePath + "whdemos_IISDefault-Custom.html")
	ConfigureCustomError      $AWebSiteName 500 12 ($ErrorFilePath + "whdemos_500_12_starting.html")
	ConfigureCustomError      $AWebSiteName 500 13 ($ErrorFilePath + "whdemos_500_13_busy.html")
	ConfigureCustomError      $AWebSiteName 404 4  ($ErrorFilePath + "whdemos_404_4_appnotdefined.html")
}

$AWebSiteName = "WebHub More Demos"
$SiteExists = ( (Get-WebSite $AWebSiteName -ErrorAction SilentlyContinue) -ne $null )
if ($SiteExists) {
	# should exist on lite.demos.href.com server
	PrepareEnableCustomErrors $AWebSiteName        ($ErrorFilePath + "whdemos_IISDefault-Custom.html")
	ConfigureCustomError      $AWebSiteName 500 12 ($ErrorFilePath + "whdemos_500_12_starting.html")
	ConfigureCustomError      $AWebSiteName 500 13 ($ErrorFilePath + "whdemos_500_13_busy.html")
	ConfigureCustomError      $AWebSiteName 404 4  ($ErrorFilePath + "whdemos_404_4_appnotdefined.html")
}

$AWebSiteName = "WebHub DB Demos"
$SiteExists = ( (Get-WebSite $AWebSiteName -ErrorAction SilentlyContinue) -ne $null )
if ($SiteExists) {
	# should exist on db.demos.href.com server
	PrepareEnableCustomErrors $AWebSiteName        ($ErrorFilePath + "whdemos_IISDefault-Custom.html")
	ConfigureCustomError      $AWebSiteName 500 12 ($ErrorFilePath + "whdemos_500_12_starting.html")
	ConfigureCustomError      $AWebSiteName 500 13 ($ErrorFilePath + "whdemos_500_13_busy.html")
	ConfigureCustomError      $AWebSiteName 404 4  ($ErrorFilePath + "whdemos_404_4_appnotdefined.html")
}

$AWebSiteName = "Delphi Prefix Registry"
$SiteExists = ( (Get-WebSite $AWebSiteName -ErrorAction SilentlyContinue) -ne $null )
if ($SiteExists) {
	# should exist on db.demos.href.com server
	PrepareEnableCustomErrors $AWebSiteName        ($ErrorFilePath + "whdemos_IISDefault-Custom.html")
	ConfigureCustomError      $AWebSiteName 500 12 ($ErrorFilePath + "whdemos_500_12_starting.html")
	ConfigureCustomError      $AWebSiteName 500 13 ($ErrorFilePath + "whdemos_500_13_busy.html")
	ConfigureCustomError      $AWebSiteName 404 4  ($ErrorFilePath + "whdemos_404_4_appnotdefined.html")
}

Remove-Variable AWebSiteName
Remove-Variable ErrorFilePath
Remove-Variable SiteExists

