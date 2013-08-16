cd /d %~dp0
set servicename=htfd
call MakeCServerVersionResource.bat

cd /d %~dp0
set servicename=adv
call MakeCServerVersionResource.bat

cd /d %~dp0
set servicename=demos
call MakeCServerVersionResource.bat

cd /d %~dp0
set servicename=bw
call MakeCServerVersionResource.bat
