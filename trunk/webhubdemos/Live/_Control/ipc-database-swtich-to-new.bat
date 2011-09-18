cd /d d:\Apps\HREFTools\WebHub\bin

ShutdownWHApps.exe
net stop w3svc

rem wait until all WebHub EXEs (including WebHubAdmin) have closed
pause

net stop hub
d:\Apps\HREFTools\MiscUtil\wait.exe 10

copy hub_d16_win32_debug_newipc.exe hub.exe
copy webhubadmin_newipc.exe WebHubAdmin.exe

cd whRunner
copy runisa_newipc.dll runisa.dll

cd /d %~dp0
cd ..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x Database-bin-newipc.7z -aoa 
if errorlevel 1 pause

cd ..\..\Library
d:\Apps\Utilities\7Zip\7z.exe x Database-Library-bin-newipc.7z -aoa 
if errorlevel 1 pause

cd /d D:\AppsData\ZaphodsMap\HREFTools\Install
copy ZMKeybox-newipc.xml ZMKeybox.xml

net start hub
d:\Apps\HREFTools\MiscUtil\wait.exe 10

cd /d %~dp0
call run-lite.demos.bat

net start w3svc
