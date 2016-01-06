:: run-db-demos.bat
:: Copyright (c) 2011-2016 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

net stop w3svc

set longdelay=40
set shortdelay=30

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
if "%demodpr%"=="yes" start whDPrefix.exe 
if "%demodpr%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %longdelay%
if "%demodpr%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=dpr --minutes=99999 "--reason=Try on http://delphiprefix.href.com/"

rem CodeRage Schedule and Archive
if "%democoderage%"=="yes" start whSchedule.exe 
if "%democoderage%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %longdelay%
if "%democoderage%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=coderage --minutes=999 --reason="upgrading"

if "%demojpeg%"=="yes" start whDynamicJPEG.exe 
if "%demojpeg%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %longdelay%
if "%demojpeg%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=jpeg --minutes=%covermin% --reason=%coverreason%
 
if "%demohtcl%"=="yes" start whClone.exe   
if "%demohtcl%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtcl%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htcl --minutes=%covermin% --reason=%coverreason%

if "%demohtfs%"=="yes" start whFishStore.exe     
if "%demohtfs%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtfs%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htfs --minutes=%covermin% --reason=%coverreason%

if "%demofire%"=="yes" start whFirebird.exe 
if "%demofire%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %longdelay%
if "%demofire%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=fire --minutes=%covermin% --reason=%coverreason%

if "%demohtfm%"=="yes" start whInstantForm.exe   
if "%demohtfm%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtfm%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htfm --minutes=%covermin% --reason=%coverreason%

if "%demodbhtml%"=="yes" start whLoadFromDB.exe  
if "%demodbhtml%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demodbhtml%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=dbhtml --minutes=%covermin% --reason=%coverreason%

if "%demohtq1%"=="yes" start whQuery1.exe    
if "%demohtq1%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtq1%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htq1 --minutes=9999999 --reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq2%"=="yes" start whQuery2.exe  
if "%demohtq2%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtq2%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htq2 --minutes=9999999 --reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq3%"=="yes" start whQuery3.exe   
if "%demohtq3%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtq3%"=="no" d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htq3 --minutes=9999999 --reason="disabled; contact techsupport if you need to see this demo"

if "%demohtq4%"=="yes" start whQuery4.exe   
if "%demohtq4%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demohtq4%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=htq4 --minutes=9999999 --reason="disabled; contact techsupport if you need to see this demo"

if "%demoscan%"=="yes" start whScanTable.exe
if "%demoscan%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demoscan%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=scan --minutes=9999999 --reason="disabled; contact techsupport if you need to see this demo"

if "%demoshop1%"=="yes" start whShopping.exe  
if "%demoshop1%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe %shortdelay%
if "%demoshop1%"=="no"  d:\Apps\HREFTools\WebHub\bin\whadmin.exe app cover --appid=shop1 --minutes=%covermin% --reason=%coverreason%

start iisreset.exe

:end
