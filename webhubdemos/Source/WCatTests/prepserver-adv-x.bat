D:\Apps\HREFTools\WebHub\bin\whadmin.exe 0

net stop w3svc
net stop hub

del D:\temp\whSessions\*.var
del C:\temp\whTemp\ipc\*.* /q

net start w3svc
net start hub

echo Start WebHub Lite instances now
pause
