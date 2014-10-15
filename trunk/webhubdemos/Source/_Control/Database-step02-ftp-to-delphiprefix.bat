:: use the ncftp utility to post the files to the server using ftp
:: ncftp is freely available yet its author would appreciate a donation

:: use zmset.bat to pull credentials from a local config file
:: zmset and ZMLookup are freely available from HREF Tools
:: Pascal source is included with ZaphodsMap 
:: www.zaphodsmap.com

setlocal

:: switch to the location of this BAT file
cd %~dp0
:: switch to the location of the 7z files
cd ..\..\Live\WebHub\Apps

call %ZaphodsMap%zmset.bat h UsingKey2Value "HREFTools\FileTransfer FTP wesleywhdemos-host"
call %ZaphodsMap%zmset.bat u UsingKey2Value "HREFTools\FileTransfer FTP wesleywhdemos-user"
call %ZaphodsMap%zmset.bat p UsingKey2Value "HREFTools\FileTransfer FTP wesleywhdemos-pass"

:continue01
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/WebHub/Apps Database-dpr.7z
if errorlevel 1 pause

call %~dp0\default-compilerdigits.bat
D:\Apps\Utilities\NcFTP\ncftpput.exe -u %u% -p %p% %h% /Live/WebHub/Apps Database-Library-d%compilerdigits%.7z
if errorlevel 1 pause

:TheEnd
endlocal