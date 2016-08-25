:: svn-update-webhubdemos.bat
:: For credentials, use your sourceforge account 


@echo off
setlocal

set src=https://svn.code.sf.net/p/webhubdemos/code/trunk

if exist D:\Apps\Utilities\SVN\Collabnet\svn.exe       set svndir=D:\Apps\Utilities\SVN\Collabnet\
if exist D:\Apps\Utilities\SVN\TortoiseSVN\bin\svn.exe set svndir=D:\Apps\Utilities\SVN\TortoiseSVN\bin\

cd /d %~dp0
cd ..

echo on
%svndir%svn.exe update  --accept theirs-full
@if errorlevel 1 pause

:end
@echo off
Echo ###
pause
