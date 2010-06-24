:: param 1 = yyyymmdd

CD /D D:\Projects\webhubdemos\Live\WebRoot\webhub\echoqa

d:\Apps\Utilities\7Zip\7z.exe a -r %1_uncleaned.7z %1
pause

D:\Projects\webhubdemos\Live\WebHub\Apps\WHIgnoreChanging.exe %1\showcaseD07\ t*.txt :1204
pause

d:\Apps\Utilities\7Zip\7z.exe a -r %1_clean.7z %1
pause
