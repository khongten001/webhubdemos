:: run-lite-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemoslite UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demoslite"
echo flagdemoslite is %flagdemoslite%

:: change to the location of this bat file
cd /d %~dp0
cd ..\WebHub\Apps\

@echo on

:Lite Examples
start whLite.exe /ID=demos  
d:\Apps\HREFTools\miscutil\wait.exe 6
if NOT %flagdemoslite%==yes goto end

start whLite.exe /ID=adv 
d:\Apps\HREFTools\miscutil\wait.exe 6

start whLite.exe /ID:showcase    
d:\Apps\HREFTools\miscutil\wait.exe 12

start whLite.exe /ID:htaj    
d:\Apps\HREFTools\miscutil\wait.exe 6

rem 16-Oct-2009 start  whLite.exe /ID:brnd  
rem 16-Oct-2009 d:\Apps\HREFTools\miscutil\wait.exe 6

start whLite.exe /ID:htfd   
d:\Apps\HREFTools\miscutil\wait.exe 6

start whLite.exe /ID:form    
d:\Apps\HREFTools\miscutil\wait.exe 6

start whLite.exe /ID:fast    
d:\Apps\HREFTools\miscutil\wait.exe 6

rem 16-Oct-2009 start whLite.exe /ID:bw    
rem 16-Oct-2009 d:\Apps\HREFTools\miscutil\wait.exe 6


start whLite.exe /ID:htsc   
d:\Apps\HREFTools\miscutil\wait.exe 6

rem 16-Oct-2009 start whLite.exe /ID:joke   
rem 16-Oct-2009 d:\Apps\HREFTools\miscutil\wait.exe 6

:end
