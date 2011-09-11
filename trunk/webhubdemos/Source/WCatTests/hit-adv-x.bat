D:\Apps\HREFTools\WebHub\bin\ShutdownWHApps.exe

net stop w3svc
net stop hub

del D:\temp\whSessions\*.var
del C:\temp\whTemp\ipc\*.*

net start w3svc
net start hub

echo Start DServer X instances now
pause

cd /d D:\Apps\Microsoft\wcat

wcat.wsf -terminate -run -s 192.168.42.2 -t D:\Projects\webhubdemos\Source\WCatTests\demo-x-adv.ubr -f D:\Projects\webhubdemos\Source\WCatTests\settings.ubr -singleip -x 

pause

