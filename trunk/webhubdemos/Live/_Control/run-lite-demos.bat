:: run-lite-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemoslite UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demoslite"
echo flagdemoslite is %flagdemoslite%

:: change to the location of this bat file
cd /d %~dp0
call .\select-lite-demos.bat

set covermin=9999
set coverreason="testing selected demos; if you need to see this one, please contact techsupport"

cd /d %~dp0
cd ..\WebHub\Apps


@echo on

:Lite Examples
if "%demodemos%"=="yes" start whLite.exe /ID=demos  
if "%demodemos%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demodemos%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=demos /minutes=%covermin% /reason=%coverreason% 
if NOT %flagdemoslite%==yes goto end

if "%demoadv%"=="yes" start whLite.exe /ID=adv 
if "%demoadv%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demoadv%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=adv /minutes=%covermin% /reason=%coverreason% 

if "%demoshowcase%"=="yes" start whLite.exe /ID:showcase    
if "%demoshowcase%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 12
if "%demoshowcase%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=showcase /minutes=%covermin% /reason=%coverreason% 

if "%demohtaj%"=="yes" start whLite.exe /ID:htaj    
if "%demohtaj%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demohtaj%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htaj /minutes=%covermin% /reason=%coverreason% 

if "%demobrnd%"=="yes" start  whLite.exe /ID:brnd  
if "%demobrnd%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demobrnd%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=brnd /minutes=%covermin% /reason=%coverreason% 

if "%demohtfd%"=="yes" start whLite.exe /ID:htfd   
if "%demohtfd%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demohtfd%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htfd /minutes=%covermin% /reason=%coverreason% 

if "%demoform%"=="yes" start whLite.exe /ID:form    
if "%demoform%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demoform%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=form /minutes=%covermin% /reason=%coverreason% 

if "%demofast%"=="yes" start whLite.exe /ID:fast    
if "%demofast%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demofast%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=fast /minutes=%covermin% /reason=%coverreason% 

if "%demobw%"=="yes" start whLite.exe /ID:bw    
if "%demobw%"=="yes"  d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demobw%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=bw /minutes=%covermin% /reason=%coverreason% 

if "%demohtsc%"=="yes" start whLite.exe /ID:htsc   
if "%demohtsc%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demohtsc%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htsc /minutes=%covermin% /reason=%coverreason% 

if "%demojoke%"=="yes" start whLite.exe /ID:joke   
if "%demojoke%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 6
if "%demojoke%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=joke /minutes=%covermin% /reason=%coverreason% 

:end
