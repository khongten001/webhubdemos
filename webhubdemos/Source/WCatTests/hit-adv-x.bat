set whserver=192.168.42.3
:: .2 is virtualbox

REM Make sure hub and apps are running on %whserver% 
pause

D:\Apps\Microsoft\wcat\wcat.wsf -terminate -run -s %whserver% -t demo-x-adv.ubr -f settings.ubr -singleip -x 

pause

