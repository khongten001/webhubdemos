:: run-db-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%
if NOT "%flagdemosdb%"=="yes" goto end


cd /d %~dp0
call .\select-db-demos.bat


set covermin=90
set coverreason="testing selected database demos; if you need to see this one, please contact techsupport"

cd /d %~dp0
cd ..\WebHub\Apps

@echo on

:DB Examples
if "%demodsp%"=="yes" start whDSP.exe 
if "%demodsp%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 15
::DSP has an AppNotRunning page of its own
if "%demodsp%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=dsp /minutes=99999 /reason="Try on http://dsp.href.com"

rem CodeRage Schedule and Archive
if "%democoderage%"=="yes" start whSchedule.exe 
if "%democoderage%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 15
if "%democoderage%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=coderage /minutes=999 /reason="upgrading"

if "%demojpeg%"=="yes" start whDynamicJPEG.exe 
if "%demojpeg%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 15
if "%demojpeg%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=jpeg /minutes=%covermin% /reason=%coverreason%
 
if "%demohtcl%"=="yes" start whClone.exe   
if "%demohtcl%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtcl%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htcl /minutes=%covermin% /reason=%coverreason%

if "%demohtfs%"=="yes" start whFishStore.exe     
if "%demohtfs%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtfs%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htfs /minutes=%covermin% /reason=%coverreason%

if "%demofire%"=="yes" start whFirebird.exe 
if "%demofire%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 15
if "%demofire%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=fire /minutes=%covermin% /reason=%coverreason%

if "%demohtfm%"=="yes" start whInstantForm.exe   
if "%demohtfm%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtfm%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htfm /minutes=%covermin% /reason=%coverreason%

if "%demodbhtml%"=="yes" start whLoadFromDB.exe  
if "%demodbhtml%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demodbhtml%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=dbhtml /minutes=%covermin% /reason=%coverreason%

if "%demohtq1%"=="yes" start whQuery1.exe    
if "%demohtq1%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtq1%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq1 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq2%"=="yes" start whQuery2.exe  
if "%demohtq2%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtq2%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq2 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq3%"=="yes" start whQuery3.exe   
if "%demohtq3%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtq3%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq3 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq4%"=="yes" start whQuery4.exe   
if "%demohtq4%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demohtq4%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq4 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

if "%demoscan%"=="yes" start whScanTable.exe
if "%demoscan%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
if "%demoscan%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=scan /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

if "%demoshop1%"=="yes" start whShopping.exe  
if "%demoshop1%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 14
::if "%demoshop1%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=shop1 /minutes=%covermin% /reason=%coverreason%
if "%demoshop1%"=="no"  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=shop1 /minutes=99999 "/reason=access violation on startup of whShopping.exe; to be resolved; contact techsupport if important to you."

d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=store000 /minutes=9999999 /reason="Shopping Cart Jump Start Project needs to be ported to Firebird SQL"

::start whRubicon.exe 
::d:\Apps\HREFTools\miscutil\wait.exe 15
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htru /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

:end
