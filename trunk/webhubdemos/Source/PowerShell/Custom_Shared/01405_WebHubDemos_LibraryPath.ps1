# Add WebHubDemos Library Path to global PATH

$oldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path

$newPath=$oldPath+';D:\Projects\WebHubDemos\Live\Library\;D:\Projects\WebHubDemos\Live\Library64\'

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH �Value $newPath

