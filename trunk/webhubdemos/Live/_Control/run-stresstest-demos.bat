:: run-stresstest-demos.bat
:: Copyright (c) 2014-2016 HREF Tools Corp.
:: https://www.href.com

@echo off
setlocal

set fastseconds=4
set exename=whlite_x_d23_win64_src.exe

cd /d %~dp0
cd ..\WebHub\Apps

@echo on

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

net start adv1
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=joke
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

net start adv2
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=joke
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start %exename% /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%


:end
