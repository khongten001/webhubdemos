@echo off
setlocal
:: use ZaphodsMap to find compiler
:: zmset.bat and ZMLookup.exe are FREE from HREF Tools Corp. via www.zaphodsmap.com
call %ZaphodsMap%zmset.bat dcc UsingKey2Folder "HREFTools\Production\cv001 Delphi D15"
set dcc=%dcc%bin\dcc32.exe
if not exist %dcc% pause

set raizelib=K:\Vendors\Raize\CodeSite4\Source\VCL\Indy;K:\Vendors\Raize\CodeSite4\Source\VCL
set libsearchpath=h:\;h:\dcu_d15_win32;h:\pkg_d15_win32;%raizelib%
set outputroot="d:\Projects\WebHubDemos\Live\WebHub\Apps"
set pkg="vcl;vclx;vcldb;vcldbx;soaprtl;xmlrtl;inet;"
set compilerflags=CodeSite;USE_TIBODataset
set includepath=h:\;
set dcu=d:\temp\DelphiTempDCU

ren %1.cfg %1.off


@echo on
%dcc%  -w -h -b %1.dpr  -n%dcu% -E%outputroot% -D%compilerflags% -LU%pkg% -u%libsearchpath% -R%libsearchpath% -I%includepath% /$D- /$L- /$Y- /$Q- /$R
if errorlevel 1 pause

@echo off
ren %1.off %1.cfg

endlocal
