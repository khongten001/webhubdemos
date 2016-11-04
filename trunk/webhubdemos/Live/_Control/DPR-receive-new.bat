:: DPR-receive-new.bat
:: Delphi Prefix Registry, receive new binary files on production server

setlocal

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app instances stop --appid=dpr 
d:\Apps\HREFTools\MiscUtil\wait.exe 5

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=dpr --minutes=3 "--reason=upgrading web application"

start TaskMgr
rem wait until whDPrefix.exe is out of memory
pause

cd /d %~dp0
cd ..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x Database-dpr.7z -aoa
if errorlevel 1 pause

:: No drive H on WESLEY server, July 2016
if exist H:\NUL cd /d h:\
if exist H:\NUL d:\Apps\Utilities\7Zip\7z.exe x d:\Projects\WebHubDemos\live\WebHub\Apps\DriveH-source.7z -aoa

start d:\Projects\WebHubDemos\live\WebHub\Apps\whDPrefix.exe

endlocal
