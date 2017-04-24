setlocal

set CSSend=d:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild

%CSSend% /note "Running Database-step00-compile.bat" %CSLogPathParams%

cd /d %~dp0

set bits=32
@echo off
cls

call ..\..\Live\_Control\select-db-demos.bat

set demonopackages=no
call compile-whdemos-db.bat

:END
endlocal
