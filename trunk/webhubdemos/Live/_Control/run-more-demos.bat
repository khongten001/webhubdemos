:: run-more-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

@echo off
setlocal

call %ZaphodsMap%zmset.bat flagdemosmore UsingKey2Value "HREFTools/WebHub/cv004 SystemStartup demosmore"
echo flagdemosmore is %flagdemosmore%
if NOT %flagdemosmore%==yes goto end





d:
cd \projects\WebHubDemos\Live\WebHub\Apps\

@echo on

:More Examples

start whStopSpam.exe 
d:\Apps\HREFTools\miscutil\wait.exe 4


start whConverter.exe 
d:\Apps\HREFTools\miscutil\wait.exe 6

:: off 19-Sep-2011 start whASyncDemo.exe 
:: off 19-Sep-2011 d:\Apps\HREFTools\miscutil\wait.exe 6
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=htasync /minutes=999999 /reason="async feature is not yet ready for use with new-ipc"

rem start whCOM.exe 
rem d:\Apps\HREFTools\miscutil\wait.exe 6
d:\Apps\HREFTools\WebHub\bin\WHCoverMgmt.exe /cover /appid=com /minutes=999999 /reason="COM demo not ready for new-ipc; may not be converted; talk to us if you need it"

start f2hdemo.exe 
d:\Apps\HREFTools\miscutil\wait.exe 6

start whDropdown.exe 
d:\Apps\HREFTools\miscutil\wait.exe 6

start whObjectInspector.exe 
d:\Apps\HREFTools\miscutil\wait.exe 6

start whOutline.exe 
d:\Apps\HREFTools\miscutil\wait.exe 4

start whSendMail.exe   
d:\Apps\HREFTools\miscutil\wait.exe 4


start whText2Table.exe 
d:\Apps\HREFTools\miscutil\wait.exe 4

:end
