setlocal

set bits=64

d:\Apps\HREFTools\WebHub\bin\ShutdownWHApps.exe
start TaskMgr
rem wait until all demos are out of memory
pause

d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=demos /minutes=10 "/reason=upgrading web application"

cd /d %~dp0
cd ..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x LiteMore-bin.7z -aoa
if errorlevel 1 pause

if "%bits%"=="32" cd ..\..\Library
if "%bits%"=="64" cd ..\..\Library64
d:\Apps\Utilities\7Zip\7z.exe x LiteMore-Library%bits%-bin.7z -aoa
if errorlevel 1 pause

:: now call startup procedure

endlocal
