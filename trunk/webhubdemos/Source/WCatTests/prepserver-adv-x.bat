D:\Apps\HREFTools\WebHub\bin\ShutdownWHApps.exe

net stop w3svc
net stop hub

del D:\temp\whSessions\*.var
del C:\temp\whTemp\ipc\*.* /q

net start w3svc
net start hub

echo Start DServer X instances now
pause
