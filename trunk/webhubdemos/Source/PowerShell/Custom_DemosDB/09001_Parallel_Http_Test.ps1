# Parallel Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"parallel http" ok')
echo $InfoMsg
#Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

workflow Http-WebHub-Runner-Workflow {
    $NRepeat = 4
	$myArray = @(
        "http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:echo", 
        "http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:pcv",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::1",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::3"
       )

    ForEach ($number in 1..$NRepeat ) {	
	    ForEach -Parallel ($a in $myArray) {
		    #echo ('Number: ' + $number)
		    $Content = Invoke-WebRequest -URI $a
            $charlen = $Content.RawContentLength
		    echo ($a + " has length " + $charlen)
	    }
    }
}

Http-WebHub-Runner-Workflow
