@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_win64.bat [%1]" %CSLogPathParams%
call %~dp0\default-compilerdigits.bat

setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set wbits=64
if "%compilerdigits%"=="24" set raizepath=%cslibroot%\RX10.1\win%wbits%
if "%compilerdigits%"=="23" set raizepath=%cslibroot%\RX10\win%wbits%
if "%compilerdigits%"=="22" set raizepath=%cslibroot%\RS-XE8\win%wbits%
if "%compilerdigits%"=="21" set raizepath=%cslibroot%\RS-XE7\win%wbits%
if "%compilerdigits%"=="20" set raizepath=%cslibroot%\RS-XE6\win%wbits%
if "%compilerdigits%"=="19" set raizepath=%cslibroot%\RS-XE5\win%wbits%
if "%compilerdigits%"=="18" set raizepath=%cslibroot%\RS-XE4\win%wbits%
if "%compilerdigits%"=="17" set raizepath=%cslibroot%\RS-XE3\win%wbits%

set ibopath=K:\Vendors\CPS\IBObjects\v5.x\source\common;K:\Vendors\CPS\IBObjects\v5.x\source\tdataset;K:\Vendors\CPS\IBObjects\v5.x\source\tools;K:\Vendors\CPS\IBObjects\v5.x\source\core;K:\Vendors\CPS\IBObjects\v5.x\source\access
set libsearchpath="h:\;h:\dcu_d%compilerdigits%_win64;h:\pkg_d%compilerdigits%_win64;k:\Rubicon\source;%ibopath%;%droot%lib\win64\release;D:\vcl\NexusDB4;D:\Projects\webhubdemos\Source\WHApps\Common;"
:: async requires OTL OmniThreadLibrary
:: showcase: AWS file upload and file download requires Chilkat
set libsearchpath=%libsearchpath%;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only\src;D:\Projects\webhubdemos\Source\WHApps\Externals\omnithreadlibrary-read-only;D:\Projects\webhubdemos\Source\WHApps\Externals\chilkat-9.5.0-delphi
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
:: exclude WebHub packages
set pkg="dbrtl;inet;soaprtl;soapserver;vclactnband;vcldb;vclimg;vclsmp;vcl;vclx;vcldb;xmlrtl;ldiRegExLib;ZaphodsMapLib"
set compilerflags=PREVENTSVCMGR;use_IBO;USE_TIBODataset;INHOUSE
if "%1"=="whLite"  set compilerflags=%compilerflags%;AWSSUPPORT
if "%1"=="DServer" set compilerflags=%compilerflags%;AWSSUPPORT
set includepath=h:\;k:\Rubicon\source\inc;K:\Vendors\CPS\IBObjects\v5.x\source\common;

:: extra parameters for Delphi XE2
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell

if exist %1.cfg REN %1.cfg %1.off

@echo on
set ok=y
"%dcc%"  -w -h -b %1.dpr  -nd:\temp\DelphiTempDCU -E%outputroot% -DCodeSite;Log2CSL -D%compilerflags% -LU%pkg% -u%libsearchpath%;%RaizePath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok=n
if "%ok%"=="n" %CSSend% /error "D%compilerdigits% %1.dpr" %CSLogPathParams%
if "%ok%"=="y" %CSSend% "success D%compilerdigits% %1.dpr" %CSLogPathParams%
if "%ok%"=="n" pause

@echo off
if exist %1.off REN %1.off %1.cfg
