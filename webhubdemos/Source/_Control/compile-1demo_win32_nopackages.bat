@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_win32_nopackages.bat %1"  %CSLogPathParams%

call %~dp0\default-compilerdigits.bat

setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc32.exe
if not exist %dcc% pause

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set wbits=32
if "%compilerdigits%"=="25" set raizepath=%cslibroot%\RX10.2\win%wbits%
if "%compilerdigits%"=="24" set raizepath=%cslibroot%\RX10.1\win%wbits%
if "%compilerdigits%"=="23" set raizepath=%cslibroot%\RX10\win%wbits%
if "%compilerdigits%"=="22" set raizepath=%cslibroot%\RS-XE8\win%wbits%
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win32;k:\Rubicon\source;%droot%lib\win32\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE;%compilerflagsplus%
set includepath=h:\;k:\Rubicon\source\inc;

if NOT "%compilerflagsplus%"=="" %CSSend% "compilerflags" "%compilerflags%"  %CSLogPathParams%

:: extra parameters for Delphi XE2+
set dccflags=--no-config -GD -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
if "%compilerdigits%"=="20" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
if "%compilerdigits%"=="22" set dccflags=%dccflags%;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


%CSSend% "no-packages d%compilerdigits%_win32 %1"  %CSLogPathParams%

@echo on
"%dcc%"  %1.dpr  -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%raizepath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause

@echo off

