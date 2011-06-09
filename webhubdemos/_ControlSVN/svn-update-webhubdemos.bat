:: svn-update-webhubdemos.bat
:: For svn login, visit http://lite.demos.href.com/demos:pgDownload::demos


@echo off
setlocal

set src=http://svn.href.com/svn-public/projects/project-whdemos/trunk
set svndir=d:\Apps\Utilities\SVN\Console

cd /d %~dp0
cd ..

echo on
%svndir%\svn.exe update 
@if errorlevel 1 pause

:end
@echo off
Echo ###
pause
