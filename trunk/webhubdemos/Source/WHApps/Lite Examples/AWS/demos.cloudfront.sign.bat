CD /D %~dp0

setlocal
set opensslexe=D:\Apps\OpenSSL\OpenSSL-Win64\bin\openssl.exe

type demos.cloudfront.policy.json | %opensslexe% sha1 -sign demos.cloudfront.pem | %opensslexe% base64 -A > demos.cloudfront.signed.viaopenssl.base64.output.txt

pause
type demos.cloudfront.signed.viaopenssl.base64.output.txt
pause
