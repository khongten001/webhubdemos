@echo off
set CSSend=P:\AllHREFToolsProducts\Pak\AllSetupProduction\PakUtilities\CodeSiteConsole.exe
%CSSend% /note "compile-1demo_win64_svc.bat [%1]"

call %~dp0\default-compilerdigits.bat
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
echo droot %droot%

set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

if "%compilerdigits%"=="17" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE3\Win64
if "%compilerdigits%"=="18" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE4\Win64
if "%compilerdigits%"=="19" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE5\Win64
if "%compilerdigits%"=="20" set raizelib=K:\Vendors\Raize\CodeSite5\Lib\RS-XE6\Win64

set libsearchpath="K:\webhub\lib;K:\webhub\lib\whvcl;K:\webhub\lib\whplus;K:\webhub\lib\whplus\cc;K:\webhub\lib\whdb;K:\webhub\tpack;K:\webhub\lib\wheditors;K:\webhub\lib\whrun;k:\webhub\zaphodsmap;k:\webhub\regex;%raizelib%;%droot%lib\win64\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;vcldb;soaprtl;xmlrtl;inet;"
if     "%raizelib%"=="" set compilerflags=USE_TIBODataset;INHOUSE;WEBHUBACE
:: LogAppTick
if NOT "%raizelib%"=="" set compilerflags=USE_TIBODataset;INHOUSE;WEBHUBACE;CodeSite;Log2CSL;LogSTime
%CSSend% compilerflags "%compilerflags%"
set includepath=h:\;
set dcu=d:\temp\DelphiTempDCU
set objpath=K:\WebHub\regex\Pcre-Delphi-Win64-msc

:: extra parameters for Delphi XE2+
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


if exist %1.cfg REN %1.cfg %1.off

%CSSend% "1demo as-service d%compilerdigits%_win64 %1"

@echo on
set ok1=yes
"%dcc%" %1.dpr  -w -h -b -n%dcu% "-O%objpath%" -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile"
if "%ok1%"=="no" pause

@echo off
if exist %1.off REN %1.off %1.cfg

endlocal
