setlocal

d:\Apps\HREFTools\WebHub\bin\ShutdownWHApps.exe
rem wait until all demos are out of memory
pause

d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=demos /minutes=10 "/reason=upgrading web application"

cd /d %~dp0
cd ..\WebHub\Apps

ren WHIgnoreChanging.exe WHIgnoreChanging.save
del wh*.exe
ren WHIgnoreChanging.save WHIgnoreChanging.exe

d:\Apps\Utilities\7Zip\7z.exe x Database-bin.7z -aoa
if errorlevel 1 pause

cd ..\..\Library
d:\Apps\Utilities\7Zip\7z.exe x Database-Library-bin.7z -aoa
if errorlevel 1 pause

:: now call startup procedure

endlocal
