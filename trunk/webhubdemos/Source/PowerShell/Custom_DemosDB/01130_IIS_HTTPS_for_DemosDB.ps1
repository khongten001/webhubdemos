# Use CERTREQ to make a new HTTPS certificate request

# References
# 1 = http://technet.microsoft.com/en-us/library/dn296456.aspx
# 2 = https://technet.microsoft.com/en-us/library/ff625722%28v=ws.10%29.aspx
# 3 = http://blogs.technet.com/b/pki/archive/2009/08/05/how-to-create-a-web-server-ssl-certificate-manually.aspx
# Note that CERTREQ is included in Win2012 Server and many other versions of Windows.



# call a separate script to init global variables.
Invoke-Expression ($PSScriptRoot + '\..\WebHub_Appliance_PS\Initialize.ps1')  # loops back and uses custom values

# include EZUtil functions
."$Global:EzUtil"

$RequestINFFilespec = "D:\Projects\webhubdemos\Live\ssl\Cert_Request_db.demos.href.com.inf"
$REQFilespec = "D:\Projects\webhubdemos\Live\ssl\Cert_Request_db.demos.href.com.req.txt"
$CERFilespec = "D:\Projects\webhubdemos\Live\ssl\db.demos.href.com.crt"
Start-Process "CERTREQ" -ArgumentList ('-New "' + $RequestINFFilespec + '" "' + $REQFilespec + '"') -NoNewWindow -Wait

Start-Process $Global:CSConsole -ArgumentList '-Note "You should pass the REQUEST data to your secure certificate provider"' -NoNewWindow -Wait
Start-Process $Global:CSConsole -ArgumentList '-Note "Recommended providers are DigiCert, CACert.org, LetsEncrypt.org"' -NoNewWindow -Wait

Start-Process $Global:CSConsole -ArgumentList ('"Opening the REQUEST file in Notepad for your convenience" "' + $REQFilespec + '"') -NoNewWindow -Wait
Start-Process "Notepad" -ArgumentList $REQFilespec -NoNewWindow -Wait

echo .
echo .
echo "Press any key to continue -- best to do this"
echo "AFTER you have submitted the REQUEST..."
echo $REQFilespec
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# http://technet.microsoft.com/en-us/library/ee692792.aspx
# This is called a "HERE" file.
# No Leading Space.
$x = @"
// Placeholder.
// When you have the response from the secure certificate provider,
// replace all this with your secure certificate code.
"@
$x | out-file -filepath $CERFilespec -encoding ASCII 

Start-Process $Global:CSConsole -ArgumentList ('"Opening the RESPONSE CERTIFICATE file in Notepad for your convenience" "' + $CERFilespec + '"') -NoNewWindow -Wait
Start-Process "Notepad" -ArgumentList $CERFilespec -NoNewWindow -Wait

echo .
echo .
echo "Press any key to continue -- "
echo "AFTER you have saved the CERTIFICATE file"
echo $CERFilespec
echo "(from Notepad)..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Start-Process "CERTREQ" -ArgumentList ('-Accept "' + $CERFilespec + '"') -NoNewWindow -Wait

$webSiteName = "WebHub Demos"
$certDomain = 'db.demos.href.com'

$ezutil.bindCertToHostHeader($webSiteName, $certDomain)
