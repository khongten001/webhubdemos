:: run-lite-demos.bat
:: Copyright (c) 2011-2016 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemoslite UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demoslite"
echo flagdemoslite is %flagdemoslite%

set fastseconds=9
set slowseconds=20

:: change to the location of this bat file
cd /d %~dp0
call .\select-lite-demos.bat

set covermin=9999
set coverlite=try this demo on http://lite.demos.href.com/

cd /d %~dp0
cd ..\WebHub\Apps


@echo on

:Lite Examples
if "%demodemos%"=="yes" start whLite.exe /ID=demos  
if "%demodemos%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demodemos%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=demos --minutes=%covermin% "--reason=%coverlite%"
if NOT %flagdemoslite%==yes goto end

if "%demoadv%"=="yes" start whLite.exe /ID=adv 
if "%demoadv%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demoadv%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=adv --minutes=%covermin% "--reason=%coverlite%"

if "%demoshowcase%"=="yes" start whLite.exe /ID:showcase    
if "%demoshowcase%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %slowseconds%
if "%demoshowcase%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=showcase --minutes=%covermin% "--reason=%coverlite%"

if "%demohtaj%"=="yes" start whLite.exe /ID:htaj    
if "%demohtaj%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demohtaj%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htaj --minutes=%covermin% "--reason=%coverlite%"

if "%demohtfd%"=="yes" start whLite.exe /ID:htfd   
if "%demohtfd%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demohtfd%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htfd --minutes=%covermin% "--reason=%coverlite%"

if "%demoform%"=="yes" start whLite.exe /ID:form    
if "%demoform%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demoform%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=form --minutes=%covermin% "--reason=%coverlite%"

if "%demofast%"=="yes" start whLite.exe /ID:fast    
if "%demofast%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demofast%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=fast --minutes=%covermin% "--reason=%coverlite%"

if "%demohtsc%"=="yes" start whLite.exe /ID:htsc   
if "%demohtsc%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demohtsc%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htsc --minutes=%covermin% "--reason=%coverlite%"

if "%demojoke%"=="yes" start whLite.exe /ID:joke   
if "%demojoke%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %fastseconds%
if "%demojoke%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=joke --minutes=%covermin% "--reason=%coverlite%"

:end
