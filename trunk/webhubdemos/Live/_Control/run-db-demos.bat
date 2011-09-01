:: run-db-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemosdb UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosdb"
echo flagdemosdb is %flagdemosdb%
if NOT %flagdemosdb%==yes goto end




d:
cd \projects\WebHubDemos\Live\WebHub\Apps\

@echo on

:DB Examples
start whDSP.exe 
d:\Apps\HREFTools\miscutil\wait.exe 15

rem CodeRage
REM  29-Dec-2010 start whSchedule.exe 
REM d:\Apps\HREFTools\miscutil\wait.exe 15

start whDynamicJPEG.exe 
d:\Apps\HREFTools\miscutil\wait.exe 15

start whClone.exe   
d:\Apps\HREFTools\miscutil\wait.exe 12

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

::08Jan2011 OFF start whQuery2.exe  
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12

::08Jan2011 OFF start whQuery3.exe   
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12

::08Jan2011 OFF start whQuery4.exe   
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12

::08Jan2011 OFF code is a complete mess start whScanTable.exe  
::Missing dbExpress driver named 'Firebird' ???
::08Jan2011 OFF d:\Apps\HREFTools\miscutil\wait.exe 12

start whShopping.exe  
d:\Apps\HREFTools\miscutil\wait.exe 12

::start whRubicon.exe 
::d:\Apps\HREFTools\miscutil\wait.exe 15

:end
