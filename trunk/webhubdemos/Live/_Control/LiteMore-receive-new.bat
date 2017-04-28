setlocal

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app instances stop all
start TaskMgr
rem wait until all demos are out of memory
pause

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=demos --minutes=10 "--reason=upgrading web application"

cd /d %~dp0..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x LiteMore-bin.7z -aoa
if errorlevel 1 pause

cd /D C:\Library64
if errorlevel 1 pause

d:\Apps\Utilities\7Zip\7z.exe x .\LiteMore-Library64-bin.7z -aoa
if errorlevel 1 pause

:: now call startup procedure

endlocal
