::for Chromium Demo
::GetExternals.bat
@echo off

::Chromium Embedded Framework = CEF
:getChromiumEmbedded
cd /d %~dp0\Externals
set src=http://delphichromiumembedded.googlecode.com/svn/trunk
svn.exe export %src% .\CEF1 --force
if errorlevel 1 pause

:: get an extra copy of DLL etc. files needed in same folder as compiled EXE
::cd /d %~dp0\..\TempBuild\Bin
::set src=http://delphichromiumembedded.googlecode.com/svn/trunk/bin/Win32 
::svn export %src% .\Win32 --force

:END
