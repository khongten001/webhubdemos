:: svn-update-webhubdemos.bat
:: For svn login, visit http://lite.demos.href.com/demos:pgDownload::demos


@echo off
setlocal

set src=http://svn.href.com/svn-public/projects/project-whdemos/trunk
if exist D:\Apps\Utilities\SVN\Collabnet\svn.exe       set svndir=D:\Apps\Utilities\SVN\Collabnet\
if exist D:\Apps\Utilities\SVN\TortoiseSVN\bin\svn.exe set svndir=D:\Apps\Utilities\SVN\TortoiseSVN\bin\
if exist D:\Apps\Utilities\SVN\Console\svn.exe         set svndir=d:\Apps\Utilities\SVN\Console\

cd /d %~dp0
cd ..

echo on
%svndir%svn.exe update  --accept theirs-full
@if errorlevel 1 pause

:end
@echo off
Echo ###
pause
