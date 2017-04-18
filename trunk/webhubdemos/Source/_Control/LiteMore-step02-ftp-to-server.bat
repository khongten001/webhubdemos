:: use the ncftp utility to post the files to the server using ftp
:: ncftp is freely available yet its author would appreciate a donation

:: use zmset.bat to pull credentials from a local config file
:: zmset and ZMLookup are freely available from HREF Tools
:: Pascal source is included with ZaphodsMap 
:: www.zaphodsmap.com

setlocal
set bits=64

:: switch to the location of this BAT file
cd %~dp0
:: switch to the location of the 7z files
cd ..\..\Live\WebHub\Apps

set h=lite.demos.href.com

call %ZaphodsMap%zmset.bat u UsingKey2Value "HREFTools\FileTransfer FTP webhubdemos-lite-user"
call %ZaphodsMap%zmset.bat p UsingKey2Value "HREFTools\FileTransfer FTP webhubdemos-lite-pass"

D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/WebHub/Apps LiteMore-bin.7z
if errorlevel 1 pause
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Library%bits% LiteMore-Library%bits%-bin.7z
if errorlevel 1 pause

endlocal