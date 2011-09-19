set covermin=999999
set url="http://lite.demos.href.com/demos:pgEnterLiteDEMOS"
set coverreason="MOVED to <a href=%url%>lite.demos.href.com</a>"

cd /d d:\Apps\HREFTools\WebHub\bin

WHCoverMgmt.exe /cover /appid=adv /minutes=%covermin% /reason=%coverreason%
WHCoverMgmt.exe /cover /appid=bw /minutes=%covermin% /reason=%coverreason%
WHCoverMgmt.exe /cover /appid=joke /minutes=%covermin% /reason=%coverreason%
WHCoverMgmt.exe /cover /appid=showcase /minutes=%covermin% /reason=%coverreason%

