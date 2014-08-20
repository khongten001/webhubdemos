:: run-stresstest-demos.bat
:: Copyright (c) 2014 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

set fastseconds=6

cd /d %~dp0
cd ..\WebHub\Apps

@echo on

start whlite_x_d20_win32_debug_src.exe /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=adv
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=bw
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=adv
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=bw
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%

start whlite_x_d20_win32_debug_src.exe /ID=htfd
d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%


:end
