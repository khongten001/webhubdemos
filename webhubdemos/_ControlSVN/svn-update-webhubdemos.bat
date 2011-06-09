:: svn-update-webhubdemos.bat
:: For svn login, visit http://lite.demos.href.com/demos:pgDownload::demos


@echo off
setlocal

set src=http://svn.href.com/svn-public/projects/project-whdemos/trunk
set svndir=d:\Apps\Utilities\SVN\Console

cd /d %~dp0
cd ..
cd ..

:: http://support.microsoft.com/kb/65994
IF NOT EXIST .\webhubdemos\NUL GOTO TargetFolderMissing

%svndir%\svn.exe update %src%/webhubdemos  ./webhubdemos 
if errorlevel 1 pause
goto end

TargetFolderMissing:
rem Target folder must be named webhubdemos
pause

end: