cd /d d:\Apps\HREFTools\WebHub\bin

ShutdownWHApps.exe
net stop w3svc

rem wait until all WebHub EXEs have closed
pause

net stop hub

copy hub_d16_win32_debug_newipc.exe hub.exe
copy webhubadmin_newipc.exe WebHubAdmin.exe

cd whRunner
copy runisa_newipc.dll runisa.dll

net start hub
net start w3svc

cd /d %~dp0
cd ..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x Database-bin-newipc.7z
if errorlevel 1 pause

cd ..\..\Library
d:\Apps\Utilities\7Zip\7z.exe x Database-Library-bin-newipc.7z
if errorlevel 1 pause

cd /d D:\AppsData\ZaphodsMap\HREFTools\Install
copy ZMKeybox-newipc.xml ZMKeybox.xml

