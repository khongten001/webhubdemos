:: svn-update-webhubdemos.bat
:: For credentials, use your sourceforge account 


@echo off
setlocal

:: set zmcontext variable
call %ZaphodsMap%zmset.bat zmcontext AsDefaultContext

set src=https://svn.code.sf.net/p/webhubdemos/code/trunk

if "%zmcontext%"=="DORIS" goto Doris
goto General

:Doris
:: case-sensitive path when file is on AWS S3
set svndir=D:\Apps\Utilities\SVN\CollabNet\
goto Continue01

:General
if exist D:\Apps\Utilities\SVN\CollabNet\svn.exe       set svndir=D:\Apps\Utilities\SVN\CollabNet\
if exist D:\Apps\Utilities\SVN\TortoiseSVN\bin\svn.exe set svndir=D:\Apps\Utilities\SVN\TortoiseSVN\bin\

:Continue01
cd /d %~dp0
cd ..

echo on
%svndir%svn.exe update  --accept theirs-full
@if errorlevel 1 pause

:end
@echo off
Echo ###
pause
