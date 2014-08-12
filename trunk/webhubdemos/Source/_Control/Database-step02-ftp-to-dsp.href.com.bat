:: use the ncftp utility to post the files to the server using ftp
:: ncftp is freely available yet its author would appreciate a donation

:: use zmset.bat to pull credentials from a local config file
:: zmset and ZMLookup are freely available from HREF Tools
:: Pascal source is included with ZaphodsMap 
:: www.zaphodsmap.com

setlocal

@echo off
set /P z1=Do you want to FTP the first zip file? y/n/a: 
set /P z2=Do you want to FTP the second zip file? y/n: 
set /P z3=Do you want to FTP the third zip file? y/n: 

echo on


:: switch to the location of this BAT file
cd %~dp0
:: switch to the location of the 7z files
cd ..\..\Live\WebHub\Apps

set h=dsp.href.com
call %ZaphodsMap%zmset.bat u UsingKey2Value "HREFTools\FileTransfer FTP webhubdemos-database-user"
call %ZaphodsMap%zmset.bat p UsingKey2Value "HREFTools\FileTransfer FTP webhubdemos-database-pass"

if "%z1%"=="n" goto continue01
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/WebHub/Apps DriveH-source.7z
if errorlevel 1 pause

:continue01
if "%z2%"=="n" goto continue02
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/WebHub/Apps Database-dsp.7z
if errorlevel 1 pause

:continue02
if "%z3%"=="n" goto TheEnd
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/Library Database-Library-bin.7z
if errorlevel 1 pause

:TheEnd
endlocal