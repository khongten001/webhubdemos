# (Ideally Parallel) Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

Remove-Variable NRepeat
Set-Variable -Name NRepeat -value 40 -Scope script -option ReadOnly

Remove-Variable urlPrefix -Force
Set-Variable urlPrefix "http://delphiprefix.modulab.com/scripts/runisa_x_d23_win64.dll?" -option ReadOnly

$InfoMsg = ('"parallel testing" "of ' + $NRepeat + ' http requests"')
echo $InfoMsg
#Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

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

# this should return $False
# SizeCloseTo 633 2209

    
    Set-Variable -Name collectionGoal -Value @() -Scope script

   
    #echo $urlPrefx
      
    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "r:echo")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 2209
    $collectionGoal += $testObj

    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "adv:pgTestLoremIpsum::2")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 10321
    $collectionGoal += $testObj

    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "adv:pgTestLoremIpsum:888888:2")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 10321
    $collectionGoal += $testObj

    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "invalid:invalid")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 633
    $collectionGoal += $testObj

    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "adv:pgTestLoremIpsum:888888:3")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 15244
    $collectionGoal += $testObj

    $testObj = New-Object System.Object
    $testObj | Add-Member -type NoteProperty -name AURL -value ($urlPrefix + "adv:pgTestLoremIpsum::4")
    $testObj | Add-Member -type NoteProperty -name IExpectedSize -value 20167
    $collectionGoal += $testObj

    # echo $collectionGoal

#  ForEach -Parallel is valid only in a Windows PowerShell *Workflow*  (not valid in a regular function)

WorkFlow Http-WebHub-Runner-Workflow { Param($NRepeat, $collectionGoal)
    
    
    ForEach ($number in 1..$NRepeat ) {	
        echo ('Loop Counter: ' + $number)
            
	    ForEach -parallel ($objTest in $collectionGoal) {              
		    #echo ('inner Number: ' + $number)
            #echo ("AURL " + $objTest.AURL)
		    $Content = Invoke-WebRequest $objTest.AURL -TimeoutSec 5 
            $charlen = [int]$Content.RawContentLength;
            #echo $charlen
            $aok = SizeCloseTo $charlen $objTest.IExpectedSize;
            
            if ($aok) {
		        echo ($objTest.AURL + " has length " + $charlen)
                #echo ('ok ' + $charlen)
            } else {
                Write-Error ($objTest.AURL + " " + [string]$charLen + " Fails")
            
            }
	    }
    }
}

Http-WebHub-Runner-Workflow $NRepeat $collectionGoal
