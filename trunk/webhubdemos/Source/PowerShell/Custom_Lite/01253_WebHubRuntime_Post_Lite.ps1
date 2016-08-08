# IIS adjustments for WebHub Lite+More Demos

# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

if (! (Test-Path ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup'))) { 
	mkdir ($env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup')
}
copy ($PSScriptRoot + '\..\WebHub_Appliance_PS\Mod_IIS_Setup.psm1')   $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Mod_IIS_Setup\Mod_IIS_Setup.psm1
Import-Module Mod_IIS_Setup

# Disable Data Execution Prevention (for Hub, runner plus all custom WebHub EXEs)
Start-Process 'bcdedit.exe' -ArgumentList '/set nx OptIn'

# "dynamic" sites
# with WebHub apps - 64bit - StreamCatcher involved
CreateWebHubWebSite 'lite-local.demos.href.com' 'WebHub Demos' D:\isites\demos.href.com $False $False   # writeTest, 32bit
NewWebHubVirtualPath 'WebHub Demos'	'scripts' $False ""  # 64bit; default runner location
New-WebBinding -Name 'WebHub Demos' -Port 80 -HostHeader "lite.demos.href.com"    
New-WebBinding -Name 'WebHub Demos' -Port 80 -HostHeader "more.demos.href.com"    
New-WebBinding -Name 'WebHub Demos' -Port 80 -HostHeader "secure.demos.href.com"    

Start-Process 'iisreset' -NoNewWindow -Wait

StartHttpRunnerEcho 'lite-local.demos.href.com' 'scripts' $True $False  # Yes new ipc; No 32bit

Start "http://lite-local.demos.href.com/scripts/runisa.dll?h:pcv"
