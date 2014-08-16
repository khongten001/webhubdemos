:: run-more-demos.bat
:: Copyright (c) 2011-2014 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemosmore UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosmore"
echo flagdemosmore is %flagdemosmore%
if NOT %flagdemosmore%==yes goto end

cd /d %~dp0
call .\select-more-demos.bat

set covermin=9999
set coverreason="testing selected demos; if you need to see this one, please contact techsupport"

cd /d %~dp0
cd ..\WebHub\Apps


@echo on

:More Examples

if "%demohtun%"=="yes" start whStopSpam.exe 
if "%demohtun%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 8
if "%demohtun%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htun /minutes=%covermin% /reason=%coverreason% 

if "%demohtcv%"=="yes" start whConverter.exe 
if "%demohtcv%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 9
if "%demohtcv%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htcv /minutes=%covermin% /reason=%coverreason% 

if "%demohtasync%"=="yes" start whASyncDemo.exe 
if "%demohtasync%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 9
if "%demohtasync%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htasync /minutes=999999 "/reason=async feature is not yet ready for use with new-ipc"

if "%demohtdr%"=="yes" start whDropdown.exe 
if "%demohtdr%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 9
if "%demohtdr%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htdr /minutes=%covermin% /reason=%coverreason% 

if "%demohtoi%"=="yes" start whOpenID.exe 
if "%demohtoi%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 9
if "%demohtoi%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htoi /minutes=%covermin% /reason=%coverreason% 

if "%demohtob%"=="yes" start whObjectInspector.exe 
if "%demohtob%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 9
if "%demohtob%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htob /minutes=%covermin% /reason=%coverreason% 

if "%demohtol%"=="yes" start whOutline.exe 
if "%demohtol%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 8
if "%demohtol%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htol /minutes=%covermin% /reason=%coverreason% 

if "%demohtem%"=="yes" start whSendMail.exe   
if "%demohtem%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 8
if "%demohtem%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htem /minutes=%covermin% /reason=%coverreason% 

if "%demohtgr%"=="yes" start whText2Table.exe 
if "%demohtgr%"=="yes" d:\Apps\HREFTools\miscutil\wait.exe 8
if "%demohtgr%"=="no" d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htgr /minutes=%covermin% /reason=%coverreason% 

:end
