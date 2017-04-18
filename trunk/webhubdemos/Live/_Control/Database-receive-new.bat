setlocal

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app instances stop all
start TaskMgr
rem wait until all demos are out of memory
pause

cd /d %~dp0
call .\select-db-demos.bat

d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=demos --minutes=10 "--reason=upgrading web application"

cd /d %~dp0
cd ..\WebHub\Apps

ren WHIgnoreChanging.exe WHIgnoreChanging.save
del wh*.exe
ren WHIgnoreChanging.save WHIgnoreChanging.exe

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"

if "%flagdemosdb%"=="yes" d:\Apps\Utilities\7Zip\7z.exe x Database-bin.7z -aoa
if errorlevel 1 pause

:: G is mapped to AWS S3 storage on the EC2 db.demos.href.com server
cd /D G:\Library32
d:\Apps\Utilities\7Zip\7z.exe x Database-Library32-bin.7z -aoa
if errorlevel 1 pause

cd /D G:\Library64
d:\Apps\Utilities\7Zip\7z.exe x Database-Library64-bin.7z -aoa
if errorlevel 1 pause

:: No drive H on DORIS server, April 2015
if exist H:\NUL cd /d h:\
if exist H:\NUL d:\Apps\Utilities\7Zip\7z.exe x d:\Projects\WebHubDemos\live\WebHub\Apps\DriveH-source.7z -aoa

:: webhub.com/dynhelp runs on db.demos server as of October 2016
set start DynHelp

:: now call startup procedure
endlocal
