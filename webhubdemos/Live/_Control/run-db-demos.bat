:: run-db-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%
if NOT %flagdemosdb%==yes goto end

set covermin=90
set coverreason="stress testing selected database demos"

set demodsp=yes
set demojpeg=no
set demohtcl=no

d:
cd \projects\WebHubDemos\Live\WebHub\Apps\

@echo on

:DB Examples
if %demodsp%==yes start whDSP.exe 
if %demodsp%==yes d:\Apps\HREFTools\miscutil\wait.exe 15
if %demodsp%==no d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=dsp /minutes=%covermin% /reason=%coverreason%

rem CodeRage
REM  29-Dec-2010 start whSchedule.exe 
REM d:\Apps\HREFTools\miscutil\wait.exe 15
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=coderage /minutes=9325322 /reason="obsolete; was for CodeRage in 2009"

if %demojpeg%==yes start whDynamicJPEG.exe 
if %demojpeg%==yes d:\Apps\HREFTools\miscutil\wait.exe 15
if %demojpeg%==no  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=jpeg /minutes=%covermin% /reason=%coverreason%
 
if %demohtcl%==yes start whClone.exe   
if %demohtcl%==yes d:\Apps\HREFTools\miscutil\wait.exe 12
if %demohtcl%==no  d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htcl /minutes=%covermin% /reason=%coverreason%

pause

start whFishStore.exe     
d:\Apps\HREFTools\miscutil\wait.exe 12

start whFirebird.exe 
d:\Apps\HREFTools\miscutil\wait.exe 15

start whInstantForm.exe   
d:\Apps\HREFTools\miscutil\wait.exe 12

start whLoadFromDB.exe  
d:\Apps\HREFTools\miscutil\wait.exe 12

::08Jan2011 OFF start whQuery1.exe    
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq1 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

::08Jan2011 OFF start whQuery2.exe  
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq2 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

::08Jan2011 OFF start whQuery3.exe   
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq3 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

::08Jan2011 OFF start whQuery4.exe   
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htq4 /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

::08Jan2011 OFF code is a complete mess start whScanTable.exe  
::Missing dbExpress driver named 'Firebird' ???
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=scan /minutes=9999999 /reason="disabled; demo needs complete upgrade off BDE"

start whShopping.exe  
d:\Apps\HREFTools\miscutil\wait.exe 12

::start whRubicon.exe 
::d:\Apps\HREFTools\miscutil\wait.exe 15
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htru /minutes=9999999 /reason="disabled; contact techsupport if you need to see this demo"

:end
