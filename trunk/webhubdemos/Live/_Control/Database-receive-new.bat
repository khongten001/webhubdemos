setlocal

d:\Apps\HREFTools\WebHub\bin\ShutdownWHApps.exe
start TaskMgr
rem wait until all demos are out of memory
pause

cd /d %~dp0
call .\select-db-demos.bat

d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=demos /minutes=10 "/reason=upgrading web application"

cd /d %~dp0
cd ..\WebHub\Apps

ren WHIgnoreChanging.exe WHIgnoreChanging.save
del wh*.exe
ren WHIgnoreChanging.save WHIgnoreChanging.exe

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"

if "%flagdemosdb%"=="yes" d:\Apps\Utilities\7Zip\7z.exe x Database-bin.7z -aoa
if errorlevel 1 pause

call %ZaphodsMap%zmset.bat flagdemosdsp UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdsp"

if "%demodsp%"=="yes" d:\Apps\Utilities\7Zip\7z.exe x Database-dsp.7z -aoa
if errorlevel 1 pause


cd ..\..\Library
d:\Apps\Utilities\7Zip\7z.exe x Database-Library-bin.7z -aoa
if errorlevel 1 pause

cd /d h:\
d:\Apps\Utilities\7Zip\7z.exe x d:\Projects\WebHubDemos\live\WebHub\Apps\DriveH-source.7z -aoa
if errorlevel 1 pause

:: now call startup procedure

endlocal
