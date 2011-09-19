set covermin=999999
set coverreason=(~APPID~) moved to <a href="http://lite.demos.href.com/">lite.demos.href.com</a>

cd /d d:\Apps\HREFTools\WebHub\bin

WHCoverMgmt.exe /cover /appid=adv /minutes=%covermin% /reason=%coverreason%
WHCoverMgmt.exe /cover /appid=bw /minutes=%covermin% /reason=%coverreason%
WHCoverMgmt.exe /cover /appid=joke /minutes=%covermin% /reason=%coverreason%

