@echo off
set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_win64_nopackages.bat [%1]"
call %~dp0\default-compilerdigits.bat
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

if "%compilerdigits%"=="21" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE7\Win64
if "%compilerdigits%"=="20" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win64
if "%compilerdigits%"=="19" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win64
if "%compilerdigits%"=="18" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win64
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win64;k:\Rubicon\source;K:\Vendors\CPS\IBObjects\v5.x;%droot%lib\win64\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg=
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


if exist %1.cfg REN %1.cfg %1.off

echo 1demo no-packages d%compilerdigits%_win64 %1

@echo on
set ok1=yes
"%dcc%"  %1.dpr  -w -h -b -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath%;%raizelib% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile"
if "%ok1%"=="no" pause
if "%ok1%"=="yes" cls

@echo off
if exist %1.off REN %1.off %1.cfg
