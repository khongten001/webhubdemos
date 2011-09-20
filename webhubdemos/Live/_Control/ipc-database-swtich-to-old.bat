cd /d d:\Apps\HREFTools\WebHub\bin

ShutdownWHApps.exe
net stop w3svc
del D:\AppsData\WebHub\WHTemp\ipc\*.* /q

rem wait until all WebHub EXEs have closed
pause

net stop hub
d:\Apps\HREFTools\MiscUtil\wait.exe 10

copy hub_oldipc.exe hub.exe
copy webhubadmin_oldipc.exe WebHubAdmin.exe

cd whRunner
copy runisa_oldipc.dll runisa.dll

net start hub

cd /d %~dp0
cd ..\WebHub\Apps

d:\Apps\Utilities\7Zip\7z.exe x Database-bin-oldipc.7z -aoa 
if errorlevel 1 pause

cd ..\..\Library
d:\Apps\Utilities\7Zip\7z.exe x Database-Library-bin-oldipc.7z -aoa 
if errorlevel 1 pause

cd /d D:\AppsData\ZaphodsMap\HREFTools\Install
copy ZMKeybox-oldipc.xml ZMKeybox.xml

cd /d %~dp0
call run-lite-demos.bat
call run-db-demos.bat

copy D:\Projects\webhubdemos\Live\scwebsites\demos.href.com\Config\SCWebSiteConfig_demos.href.com_oldipc.cfg D:\Projects\webhubdemos\Live\scwebsites\demos.href.com\Config\SCWebSiteConfig_demos.href.com.cfg 

net start w3svc
