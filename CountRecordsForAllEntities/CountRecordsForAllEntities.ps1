# Copyright © Microsoft Corporation.  All Rights Reserved.
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code 

# As this script is supposed to run on demand, create connection by using InteractiveMode, but you can embed credential if you need to.
$conn = Connect-CrmOnlineDiscovery -InteractiveMode

# Instantiate ResultSet
$results = New-Object System.Collections.Generic.List[PSObject]

# Retrieve all Entity.
$entities = Get-CrmEntityAllMetadata -conn $conn -EntityFilters Entity

# Get records for each Entity. As there maybe many records per Entity, use Write-Progress to show the progress.
$current = 1
$total = $entities.Count
$entities |  % {`
    $logicalName = $_.LogicalName;`
    $percentComplete = [System.Math]::Round($current/$total*100,1);`
    Write-Progress -Activity "Getting Records Count for: $logicalName.." -PercentComplete $percentComplete -CurrentOperation "$percentComplete% ($current/$total) Completed";`
    $count = Get-CrmRecordsCount -conn $conn -EntityLogicalName $logicalName -WarningAction SilentlyContinue -ErrorAction SilentlyContinue;`
	$result = New-Object System.Management.Automation.PSObject;`
	Add-Member -InputObject $result -MemberType NoteProperty -Name LogicalName -Value $logicalName; `
	Add-Member -InputObject $result -MemberType NoteProperty -Name RecordsCount -Value $count; `
    $results.Add($result) ;`
    $current++;`
} 

Write-Host "Top 10 records count per Entity"
$results | sort RecordsCount -Descending | select -First 10 LogicalName,RecordsCount | ft

Write-Host "Top 10 records count per User/Team owned Entity"
$results | ? {($entities | ? {$_.OwnershipType -ne "None"}).LogicalName.Contains($_.LogicalName)} | sort RecordsCount -Descending | select -First 10 LogicalName,RecordsCount | ft

Write-Host "Top 10 records count per intersect Entity"
$results | ? {($entities | ? {$_.IsIntersect -eq $true}).LogicalName.Contains($_.LogicalName)} | sort RecordsCount -Descending | select -First 10 LogicalName,RecordsCount | ft

