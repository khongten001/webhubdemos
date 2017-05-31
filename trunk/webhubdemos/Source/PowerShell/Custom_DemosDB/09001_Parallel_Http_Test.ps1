# (Ideally Parallel) Http Test
# Copyright 2016 HREF Tools Corp. 
# Creative Commons license - keep credits intact.

# call a separate script if you need to init global variables.
#Invoke-Expression "$PSScriptRoot\Initialize.ps1"

#Remove-Variable NRepeat -Force
#Set-Variable -Name NRepeat -value 500 -Option ReadOnly

Remove-Variable authority -Force
Set-Variable authority "delphiprefix.modulab.com" -Scope script -Option ReadOnly

Remove-Variable vmr -Force
Set-Variable vmr "scripts/runisa_x_d23_win64.dll" -Scope script -Option ReadOnly

Remove-Variable urlPrefix -Force
Set-Variable urlPrefix ("http://" + $authority + "/" + $vmr + "?") -Scope script -option ReadOnly

#Write-Output $urlPrefx


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

     #Write-Output $collectionGoal

#  ForEach -Parallel is valid only in a Windows PowerShell *Workflow*  (not valid in a regular function)

    #Set-Variable ErrorCount 0
        

WorkFlow Http-WebHub-Runner-Workflow { Param($NRepeat, $collectionGoal)
    
    $InfoMsg = ('"parallel testing" "of ' + $NRepeat + ' SETS of http requests"')
    Write-Output $InfoMsg
    #Start-Process $Global:CSConsole -ArgumentList $InfoMsg -NoNewWindow 

    ForEach ($number in 1..$NRepeat ) {	
        Write-Output ('Loop Counter: ' + $number)
            
	    ForEach -parallel ($objTest in $collectionGoal) {              
		    #Write-Output ('inner Number: ' + $number)
            #Write-Output ("AURL " + $objTest.AURL)
		    $Content = Invoke-WebRequest $objTest.AURL -TimeoutSec 9 
            $charlen = [int]$Content.RawContentLength;
            #Write-Output $charlen
            $aok = SizeCloseTo $charlen $objTest.IExpectedSize;
            
            if ($aok) {
		        #Write-Output ($objTest.AURL + " has length " + $charlen)
                #Write-Output ('ok ' + $charlen)
            } else {
                Write-Error ($objTest.AURL + " " + [string]$charLen + " Fails")
                $workflow:ErrorCount++
            }
	    }
    }
    Write-Output ('Error Count ' + $workflow:ErrorCount)
}

cls
Measure-Command { Http-WebHub-Runner-Workflow 200 $collectionGoal }
Write-Output sleeping...
Start-Sleep -Seconds 90
Http-WebHub-Runner-Workflow 2 $collectionGoal

