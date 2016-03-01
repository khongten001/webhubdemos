# Parallel Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"parallel testing" "of http requests"')
echo $InfoMsg
#Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

function SizeCloseTo{ Param ([int]$actualSize, [int]$expectedSize) 
  $edge1 = $expectedSize - 8
  $edge2 = $expectedSize + 8
  if ( ($edge1 -le $actualSize) -and ($edge2 -ge $actualSize)) {
    return $True
  } else {
    echo $edge1 $edge2 $actualSize $expectedSize
    return $False
  }
}

workflow Http-WebHub-Runner-Workflow {
    $NRepeat = 2
	$myArray = @(
        "http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:echo", 
        #"http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:pcv",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::2",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?demos:pgTestLoremIpsum::2",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::3",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::4"
       )

    ForEach ($number in 1..$NRepeat ) {	
	    ForEach -Parallel ($a in $myArray) {
		    #echo ('Number: ' + $number)
		    $Content = Invoke-WebRequest -URI $a
            $charlen = [int]$Content.RawContentLength
            if (SizeCloseTo $charlen 2208 -or SizeCloseTo $charlen 10321 -or SizeCloseTo $charlen 15244 -or SizeCloseTo -eq 20167) {
		        #echo ($a + " has length " + $charlen)
                echo ('ok ' + $charlen)
            } else {
                Write-Error ($a + " wrong length! " + $charlen)
            }
	    }
    }
}

Http-WebHub-Runner-Workflow
