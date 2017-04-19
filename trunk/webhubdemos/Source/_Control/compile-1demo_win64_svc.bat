@echo off
set CSSend=D:\Apps\HREFTools\MiscUtil\CodeSiteConsole.exe
set CSLogPathParams=/LogPath=D:\Projects\webhubdemos\Source\TempBuild
%CSSend% /note "compile-1demo_win64_svc.bat [%1]" %CSLogPathParams%

call %~dp0\default-compilerdigits.bat
setlocal

del d:\temp\DelphiTempDCU\*.dcu

:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat droot UsingKey2Folder "HREFTools\Production\cv001 Delphi D%compilerdigits%"
echo droot %droot%

:: use ZaphodsMap to find Raize CodeSite5 library root
call "%ZaphodsMap%zmset.bat" cslibroot UsingKey2Folder "HREFTools\Production\cv001 Delphi CodeSite5"

set dcc=%droot%bin\dcc64.exe
if not exist %dcc% pause

set wbits=64
call %~dp0set-raizepath.bat

set libsearchpath="K:\webhub\lib;K:\webhub\lib\whvcl;K:\webhub\lib\whplus;K:\webhub\lib\whplus\cc;K:\webhub\lib\whdb;K:\webhub\tpack;K:\webhub\lib\wheditors;K:\webhub\lib\whrun;k:\webhub\zaphodsmap;k:\webhub\regex;%raizepath%;%droot%lib\win64\release;"
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;vcldb;soaprtl;xmlrtl;inet;"
if     "%raizepath%"=="" set compilerflags=USE_TIBODataset;INHOUSE
:: LogAppTick;LogHelo;LogSTime;LogIPCMinimal;LOGBAD
if NOT "%raizepath%"=="" set compilerflags=USE_TIBODataset;INHOUSE;CodeSite;Log2CSL;LOGBOUNCE
if "%1"=="whLite"  set compilerflags=%compilerflags%;AWSSUPPORT
%CSSend% compilerflags "%compilerflags%" %CSLogPathParams%
set includepath=h:\;
set dcu=d:\temp\DelphiTempDCU
set objpath=K:\WebHub\regex\Pcre-Delphi-Win64-msc

:: extra parameters for Delphi XE2+
set dccflags=--no-config -M -Q -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Windows;WinProcs=Windows
set dccns=-NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell


if exist %1.cfg REN %1.cfg %1.off

%CSSend% "1demo as-service d%compilerdigits%_win64 %1" %CSLogPathParams%

:LocalRepeat
@echo on
set ok1=yes
"%dcc%" %1.dpr  -w -h -b -n%dcu% "-O%objpath%" -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R %dccflags% %dccns%
if errorlevel 1 set ok1=no
if "%ok1%"=="no" %CSSend% /error "%1.dpr failed to compile" %CSLogPathParams%
if "%ok1%"=="no" pause
if "%ok1%"=="no" goto LocalRepeat

@echo off
if exist %1.off REN %1.off %1.cfg

endlocal
