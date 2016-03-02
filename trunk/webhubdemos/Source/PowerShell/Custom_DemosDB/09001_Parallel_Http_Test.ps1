# Parallel Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

$InfoMsg = ('"parallel testing" "of http requests"')
echo $InfoMsg
#Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

<#function SizeCloseTo{ Param ([int]$actualSize, [int]$expectedSize) 
  $edge1 = $expectedSize - 8
  $edge2 = $expectedSize + 8
  if ( ($edge1 -le $actualSize) -and ($edge2 -ge $actualSize)) {
    return 1
  } else {
    # Write-Error ([string]$actualSize + " Fails for " + [string]$expectedSize)
    return 0
  }
}#>

# this should return $False
# SizeCloseTo 633 2209

workflow Http-WebHub-Runner-Workflow {
    $NRepeat = 1
	$myArray = @(
        "http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:echo", 
        #"http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?r:pcv",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::2",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?demos:pgTestLoremIpsum:888888:2",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?invalid:invalid",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum:888888:3",
        "http://delphiprefix.modulab.com/win64/runisa_x_d23_win64.dll?adv:pgTestLoremIpsum::4"
       )

function SizeCloseTo{ Param ([int]$actualSize, [int]$expectedSize) 
  $edge1 = $expectedSize - 8
  $edge2 = $expectedSize + 8
  if ( ($edge1 -le $actualSize) -and ($edge2 -ge $actualSize)) {
    return 1
  } else {
    # Write-Error ([string]$actualSize + " Fails for " + [string]$expectedSize)
    return 0
  }
}

    ForEach ($number in 1..$NRepeat ) {	
	    ForEach -Parallel ($a in $myArray) {
		    #echo ('Number: ' + $number)
		    $Content = Invoke-WebRequest -URI $a -TimeoutSec 5;
            $charlen = [int]$Content.RawContentLength;
            $aok = SizeCloseTo $charlen 2208;
            $aok = ($aok) -or (SizeCloseTo $charlen 10321);
            $aok = ($aok) -or (SizeCloseTo $charlen 15244);
            $aok = ($aok) -or (SizeCloseTo $charlen 20167);
            if ($aok) {
		        echo ($a + " has length " + $charlen)
                echo ('ok ' + $charlen)
            } else {
                Write-Error ($a + " " + [string]$charLen + " Fails")
            
            }
	    }
    }
}

Http-WebHub-Runner-Workflow
