:: select-db-demos.bat
:: Copyright (c) 2011 HREF Tools Corp.
:: www.href.com

call %ZaphodsMap%\zmset.bat whipc UsingKey2Value "HREFTools\Install WebHub ipc old"

echo .
echo ***
echo ipc is %whipc%
echo ***
echo .

if "%whipc%"=="old" set demodbhtml=yes
if "%whipc%"=="x"    set demodbhtml=no

set demodsp=yes

set democoderage=no

if "%whipc%"=="old" set demofire=yes
if "%whipc%"=="x"    set demofire=no

if "%whipc%"=="old" set demohtcl=yes
if "%whipc%"=="x"    set demohtcl=no

if "%whipc%"=="old" set demohtfm=yes
if "%whipc%"=="x"    set demohtfm=no

if "%whipc%"=="old" set demohtfs=yes
if "%whipc%"=="x"    set demohtfs=yes


set demohtq1=no
set demohtq2=no
set demohtq3=no
set demohtq4=no
set demohtru=no

if "%whipc%"=="old" set demojpeg=no
if "%whipc%"=="x"    set demojpeg=yes

set demoscan=no

if "%whipc%"=="old" set demoshop1=yes
if "%whipc%"=="x"    set demoshop1=no

set demostore000=no

:end
