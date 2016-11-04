D:\Apps\HREFTools\WebHub\bin\whadmin.exe 0

net stop w3svc
net stop hub

del D:\temp\whSessions\*.var
del C:\temp\whTemp\ipc\*.* /q

net start w3svc
net start hub

echo Start WebHub Lite instances now
pause

cd /d D:\Apps\Microsoft\wcat

wcat.wsf -terminate -run -s 192.168.42.2 -t D:\Projects\webhubdemos\Source\WCatTests\demo-old-adv.ubr -f D:\Projects\webhubdemos\Source\WCatTests\settings.ubr -singleip -x 

pause

