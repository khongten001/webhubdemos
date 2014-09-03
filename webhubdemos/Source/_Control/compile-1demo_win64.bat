@echo off
set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_win64.bat [%1]"
call %~dp0\default-compilerdigits.bat

setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win64;h:\pkg_d%compilerdigits%_win64;k:\Rubicon\source;%ibopath%;%droot%lib\win64\release;D:\vcl\NexusDB4;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
:: exclude WebHub packages
set pkg="vcl;vclx;vcldb;soaprtl;xmlrtl;inet;ldiRegExLib;ZaphodsMapLib"
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

if exist %1.cfg REN %1.cfg %1.off

@echo on
"%dcc%"  -w -h -b %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 pause

@echo off
if exist %1.off REN %1.off %1.cfg
