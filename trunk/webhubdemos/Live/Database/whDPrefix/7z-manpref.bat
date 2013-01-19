cd /d %~dp0
call d:\AppsData\winnt\bat\set-ymd.bat thisdate yyyy-mm-dd_hhnn
d:\Apps\Utilities\7Zip\7z.exe a manpref_%thisdate%.7z manpref.nx1
d:\Apps\Utilities\7Zip\7z.exe a manpref_%thisdate%.7z $sql*
pause