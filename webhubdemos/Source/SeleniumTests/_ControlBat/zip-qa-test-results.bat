:: param 1 = yyyymmdd

setlocal
set qahome=D:\Projects\webhubdemos\Live\WebRoot\webhub\echoqa
CD /D %qahome%

d:\Apps\Utilities\7Zip\7z.exe a -r %1_uncleaned.7z %1
pause

D:\Projects\webhubdemos\Live\WebHub\Apps\WHIgnoreChanging.exe %qahome%\%1\ t*.txt :1204 /s
pause

d:\Apps\Utilities\7Zip\7z.exe a -r %1_clean.7z %1
pause
