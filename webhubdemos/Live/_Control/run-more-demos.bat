:: run-more-demos.bat

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

start whASyncDemo.exe 
d:\Apps\HREFTools\miscutil\wait.exe 6

rem start whCOM.exe 
rem d:\Apps\HREFTools\miscutil\wait.exe 6


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
