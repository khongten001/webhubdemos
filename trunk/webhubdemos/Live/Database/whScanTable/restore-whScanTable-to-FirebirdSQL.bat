SETLOCAL 

:: use ZaphodsMap to find FirebirdSQL credentials
:: Note: the master copy of zmset.bat and ZMLookup.exe are here:
:: ftp://ftp9.href.com/image-href-shareware/driveroot/AppsData/ZaphodsMap
:: Login with username = HREFCustomerWin32  and password = blank

:: Reference:
:: http://webhub.com/dynhelp:alias::zmlookupfirebirdcredentials

call %ZaphodsMap%zmset.bat dbname UsingKey2Value "FirebirdSQL Credentials-WebHubDemo-scan database localhost:whdemoscan"
if errorlevel 1 pause
call %ZaphodsMap%zmset.bat u UsingKey2Value "FirebirdSQL Credentials-WebHubDemo-scan user SYSDBA"
call %ZaphodsMap%zmset.bat p UsingKey2Value "FirebirdSQL Credentials-WebHubDemo-scan pass masterkey"
call %ZaphodsMap%zmset.bat FireFolder UsingKey2Folder "FirebirdSQL Program 2.5 D:\Apps\FirebirdSQL\2.5\"

@echo off
cls

set f=D:\Projects\webhubdemos\Live\Database\whScanTable

echo This will completely replace the scan database %dbname% 
echo Using credentials: user [%u%] and password [%p%]
pause

@echo on
%FireFolder%bin\gbak -v -z -recreate_database overwrite -user %u% -password %p% %f%\whScanTable-backup.fbk %dbname%
pause
