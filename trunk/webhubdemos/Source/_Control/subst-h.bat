:: webhubdemos\Source\_Control\subst-h.bat
:: HREF Tools Corp.
:: www.href.com
::
:: This sets drive H: to point to the WebHub\lib\*.pas files

:: On Windows 7, use Task Scheduler to run this BAT whenever you log on.


subst /d h:

:: If you need to use a different path, copy this BAT and adjust accordingly.
subst h: d:\Apps\HREFTools\WebHub\lib
