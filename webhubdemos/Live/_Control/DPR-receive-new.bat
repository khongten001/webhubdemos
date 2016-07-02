setlocal

start TaskMgr
rem wait until whDPrefix.exe is out of memory
pause

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=dpr --minutes=1 "--reason=upgrading web application"

cd /d %~dp0
cd ..\WebHub\Apps

if "%flagdemosdb%"=="yes" d:\Apps\Utilities\7Zip\7z.exe x Database-dpr.7z -aoa
if errorlevel 1 pause

:: No drive H on WESLEY server, July 2016
if exist H:\NUL cd /d h:\
if exist H:\NUL d:\Apps\Utilities\7Zip\7z.exe x d:\Projects\WebHubDemos\live\WebHub\Apps\DriveH-source.7z -aoa

start d:\Projects\WebHubDemos\live\WebHub\Apps\whDPrefix.exe

endlocal
