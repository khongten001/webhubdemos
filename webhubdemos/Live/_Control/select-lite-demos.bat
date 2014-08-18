:: select-more-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

:: default to new-ipc
if "%whipc%"=="" set whipc=x

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

set demodemos=yes

if "%whipc%"=="old" set demoadv=yes
if "%whipc%"=="x"    set demoadv=yes

if "%whipc%"=="old" set demoshowcase=yes
if "%whipc%"=="x" set demoshowcase=yes

set demohtaj=yes

if "%whipc%"=="old" set demohtfd=yes
if "%whipc%"=="x" set demohtfd=yes

if "%whipc%"=="old" set demoform=yes
if "%whipc%"=="x" set demoform=yes

if "%whipc%"=="old" set demofast=yes
if "%whipc%"=="x" set demofast=yes

if "%whipc%"=="old" set demobw=no
if "%whipc%"=="x" set demobw=yes

if "%whipc%"=="old" set demohtsc=yes
if "%whipc%"=="x" set demohtsc=yes

if "%whipc%"=="old" set demojoke=no
if "%whipc%"=="x" set demojoke=yes

:end
