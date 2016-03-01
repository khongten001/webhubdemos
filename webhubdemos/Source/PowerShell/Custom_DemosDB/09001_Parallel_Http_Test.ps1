# Parallel Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"parallel http" ok')
echo $InfoMsg
#Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

workflow Http-Google-Workflow {
	$myArray = @("http://www.google.com/", "http://www.google.de/")
	
	ForEach -Parallel ($a in $myArray) {
		#echo $a
		$Content = Invoke-WebRequest -URI $a
        $charlen = $Content.RawContentLength
		echo $a "has length" $charlen
	}
}

Http-Google-Workflow
