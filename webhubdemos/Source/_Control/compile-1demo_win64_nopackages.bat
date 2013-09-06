@echo off
if "%compilerdigits%"=="" set compilerdigits=18
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win64
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win64;k:\Rubicon\source;K:\Vendors\CPS\IBObjects\v4.9.11;%droot%lib\win64\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v4.9.11

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


ren %1.cfg %1.off

echo 1demo no-packages d%compilerdigits%_win64 %1

@echo on
"%dcc%"  -w -h -b %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%raizelib% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause

@echo off
ren %1.off %1.cfg