# Configure a custom error response for 500.12 and 500.13 errors
# Copyright 2015-2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# Thanks to http://forums.iis.net/t/1185503.aspx?creating+a+custom+http+error+for+single+site+in+powershell

# call a separate script to init global variables.
## Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

Import-Module WebAdministration

$AWebSiteName = "WebHub Demos"
$InfoMsg = '"CustomHttpErrors" "WebHubDemos 500.12"'
## Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
echo $InfoMsg

Add-WebConfiguration -Filter system.webserver/httpErrors -location $AWebSiteName -Value @{StatusCode=500; substatuscode=12;  Path="d:\Projects\WebHubDemos\Live\WebRoot\webhub\demos\http_sys_msg\500_12_starting.html"; ResponseMode="File"} 

$InfoMsg = '"CustomHttpErrors" "WebHubDemos 500.13"'
## Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 
echo $InfoMsg

Add-WebConfiguration -Filter system.webserver/httpErrors -location $AWebSiteName -Value @{StatusCode=500; substatuscode=13;  Path="d:\Projects\WebHubDemos\Live\WebRoot\webhub\demos\http_sys_msg\500_13_busy.html"; ResponseMode="File"} 


