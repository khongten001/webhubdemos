@echo off
setlocal
set dcc=D:\Apps\Embarcadero\RADStudio\7.0\bin\dcc32.exe

set libsearchpath=h:\;h:\d14;h:\pkgd14;k:\Rubicon\source;k:\Rubicon\source\inc;D:\vcl\ibo\4.8.6;D:\vcl\EurekaLog6\Delphi14
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set compilerflags=PREVENTSVCMGR
set includepath=h:\;D:\vcl\ibo\4.8.6;k:\Rubicon\source;k:\Rubicon\source\inc;


cd /D D:\Projects\webhubdemos\Source\SeleniumTests\DelphiDriver\TestFileCleanup

ren WHIgnoreChanging.cfg WHIgnoreChanging.off


@echo on
%dcc%  -w -h -b WHIgnoreChanging.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R

@echo off
ren WHIgnoreChanging.off WHIgnoreChanging.cfg

:END
pause
