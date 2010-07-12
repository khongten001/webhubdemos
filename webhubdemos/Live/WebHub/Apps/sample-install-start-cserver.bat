:: Note: the ServiceName property of cserver.exe is 'webhubsample'
:: The default AppID is 'appvers'

cserver.exe -install -num=1 
cserver.exe -install -num=2 /AppID=adv
cserver.exe -install -num=3 /AppID=joke

net start webhubsample1 /AppID=fast
net start webhubsample2 
:: the third example shows that the demos allow the /AppID from the command line to take precedence
net start webhubsample3 /AppID=bw

pause
