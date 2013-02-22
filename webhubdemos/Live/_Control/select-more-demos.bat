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

set demohtdr=yes

if "%whipc%"=="old" set demohtob=yes
if "%whipc%"=="x" set demohtob=no

set demohtol=no

set demohtem=yes

if "%whipc%"=="old" set demohtgr=yes
if "%whipc%"=="x" set demohtgr=no

set demohtoi=yes

:end
