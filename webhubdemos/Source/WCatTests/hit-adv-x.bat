REM Make sure server is ready
pause

cd /d D:\Apps\Microsoft\wcat

wcat.wsf -terminate -run -s 192.168.42.2 -t D:\Projects\webhubdemos\Source\WCatTests\demo-x-adv.ubr -f D:\Projects\webhubdemos\Source\WCatTests\settings.ubr -singleip -x 

pause

