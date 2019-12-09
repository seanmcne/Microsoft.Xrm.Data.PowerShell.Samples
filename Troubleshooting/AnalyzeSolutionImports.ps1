#connect howerver you want, this is a simple way to connect and get started. 
Connect-CrmOnlineDiscovery -InteractiveMode

#dump all solution imports out to xml files for review
$results = Get-CrmRecords -EntityLogicalName importjob -FilterAttribute solutionname -FilterOperator not-like -FilterValue "activityfeeds" -Fields solutionname,progress,startedon,completedon,data -AllRows

$orderedResults = $results.CrmRecords|sort solutionname
$LastSolutionName = ""
$LastSolutionHidden = $false
$FileInfoToWrite = @()
foreach ( $record in $orderedResults) 
{
    if($LastSolutionName -eq $record.solutionname){
        if($LastSolutionHidden){
            Write-Output "Dup- Skipping: $($record.solutionname)"
            continue
        }
    }
    else{
        $LastSolutionName = ""
        $Solutions=Get-CrmRecords -EntityLogicalName solution -Fields isvisible -FilterAttribute uniquename -FilterOperator eq -FilterValue $record.solutionname
        if($Solutions.Count -eq 1){
            $LastSolutionName = $record.solutionname
            if($Solutions.CrmRecords[0].isvisible -eq "No"){
                Write-Output "Dup- Skipping: $($record.solutionname)"
                $LastSolutionHidden = $true
                continue
            }
            else{
                $LastSolutionHidden = $false
            }
        }
    }
    $fileNameForData = "$(([DateTime]($record.startedon)).ToString("yyyyMMdd_hhmmss"))_$($record.solutionname).xml"  
    $record.data > $fileNameForData
    Write-Output "Writing file with Name: $fileNameForData"
    ([xml]$record.data).InnerXml|out-file -FilePath $fileNameForData
    $FileInfoToWrite+= New-Object PSCustomObject -Property @{
        "FileName" = $fileNameForData
        "SolutionName" = $($record.solutionname) 
        "Progress" = $($record.progress)
        "StartedOn" = $($record.startedon)
        "CompletedOn" = $($record.completedon)
        "Duration" = ($record.completedon_Property.Value - $record.startedon_Property.Value).ToString()
    }
}
#dump a csv with each import job listed for review 
$FileInfoToWrite|Export-Csv SolutionImportReport.csv -NoTypeInformation 
