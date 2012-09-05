:: select-more-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

:: htcv includes file upload feature
set demohtcv=yes

set demohtun=yes

if "%whipc%"=="old" set demohtasync=no
if "%whipc%"=="x"    set demohtasync=no

if "%whipc%"=="old" set democom=no
if "%whipc%"=="x"    set democom=no

:: 4-Sep-2012 Form2Html is just not the WebHub way of doing things
set demodfm2html=no

if "%whipc%"=="old" set demohtdr=yes
if "%whipc%"=="x" set demohtdr=no

if "%whipc%"=="old" set demohtob=yes
if "%whipc%"=="x" set demohtob=no

if "%whipc%"=="old" set demohtol=yes
if "%whipc%"=="x" set demohtol=no

set demohtem=yes

if "%whipc%"=="old" set demohtgr=yes
if "%whipc%"=="x" set demohtgr=no

:end
