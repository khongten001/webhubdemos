call D:\AppsData\WinNT\Bat\set-ymd.bat thisdate yyyy-mm-dd

:: use ZaphodsMap to find credentials
call %ZaphodsMap%zmset.bat dbname UsingKey2Value "FirebirdSQL Credentials-CodeRageSchedule database"
call %ZaphodsMap%zmset.bat u UsingKey2Value "FirebirdSQL Credentials-CodeRageSchedule user"
call %ZaphodsMap%zmset.bat p UsingKey2Value "FirebirdSQL Credentials-CodeRageSchedule pass"

cls
echo %thisdate%
echo dbname %dbname%
echo user %u%
echo pass %p%
pause

cd /d %~dp0

REM gbak <options> -user <username> -password <password> <source> <destination>
D:\Apps\Firebird\Firebird_2_5\bin\gbak -v -z -user %u% -password %p% %dbname% backup\coderage_%thisdate%.fbk

pause