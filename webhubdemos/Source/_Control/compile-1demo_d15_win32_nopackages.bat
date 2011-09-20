@echo off
setlocal

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat dcc UsingKey2Folder "HREFTools\Production\cv001 Delphi D15"
set dcc=%dcc%bin\dcc32.exe
if not exist %dcc% pause

set raizelib=K:\Vendors\Raize\CodeSite4\Source\VCL\Indy;K:\Vendors\Raize\CodeSite4\Source\VCL
set libsearchpath=h:\;h:\dcu_d15_win32;k:\Rubicon\source;K:\Vendors\CPS\IBObjects\v4.9.11
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;CodeSite;LOGIPC
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v4.9.11

ren %1.cfg %1.off


@echo on
%dcc%  -w -h -b %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%raizelib% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R
if errorlevel 1 pause

@echo off
ren %1.off %1.cfg
