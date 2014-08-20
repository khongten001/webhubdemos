:: run-stresstest-demos.bat
:: Copyright (c) 2014 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

set fastseconds=6
set exename=whLite_x_d20_win32_src.exe

cd /d %~dp0
cd ..\WebHub\Apps

@echo on

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=adv
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=bw
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=adv
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=bw
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%


:end
