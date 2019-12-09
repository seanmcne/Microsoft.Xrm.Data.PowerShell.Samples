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
$results = New-Object System.Collections.Generic.List[PSCustomObject]

# Retrieve all System Views which are active.
$fetch = @"
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false" no-lock="true">
  <entity name="savedquery">
    <attribute name="name" />
    <attribute name="fetchxml" />
    <attribute name="layoutxml" />
    <attribute name="returnedtypecode" />
    <order attribute="name" descending="false" />
    <filter type="and">
      <condition attribute="querytype" operator="eq" value="0" />
      <condition attribute="statuscode" operator="eq" value="1" />
      <condition attribute="queryapi" operator="null" />
    </filter>
  </entity>
</fetch>
"@
$systemViews = Get-CrmRecordsByFetch -conn $conn -Fetch $fetch -AllRows -WarningAction SilentlyContinue

# Analyze each view and add the result to result set.
# As there maybe many views, use Write-Progress to show the progress.
$current = 1
$total =$systemViews.CrmRecords.Count
$systemViews.CrmRecords |  % {`
    $viewName = $_.name;`
    $percentComplete = [System.Math]::Round($current/$total*100,1);`
    Write-Progress -Activity "Analyzing SystemView: $viewName.." -PercentComplete $percentComplete -CurrentOperation "$percentComplete% ($current/$total) Completed";`
    $result = Test-CrmViewPerformance -conn $conn -View $_ ;`
    $results.Add($result) ;`
    $current++;`
} 

# Retrieve all User Defined Views which are active.
$fetch = @"
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false" no-lock="true">
  <entity name="userquery">
    <attribute name="name" />
    <attribute name="fetchxml" />
    <attribute name="layoutxml" />
    <attribute name="returnedtypecode" />
    <attribute name="ownerid" />
    <order attribute="name" descending="false" />
    <filter type="and">
      <condition attribute="querytype" operator="eq" value="0" />
      <condition attribute="statuscode" operator="eq" value="1" />
    </filter>
  </entity>
</fetch>
"@
$userViews = Get-CrmRecordsByFetch -conn $conn -Fetch $fetch -AllRows -WarningAction SilentlyContinue

# Analyze each view and add the result to result set.
# As User view is run under the owner context, using -RunAsViewOwner
$current = 1
$total =$userViews.CrmRecords.Count
$userViews.CrmRecords |  % {`
    $viewName = $_.name;`
    $percentComplete = [System.Math]::Round($current/$total*100,1);`
    Write-Progress -Activity "Analyzing UserView: $viewName as ViewOwner" -PercentComplete $percentComplete -CurrentOperation "$percentComplete% ($current/$total) Completed";`
    $result = Test-CrmViewPerformance -View $_ -RunAsViewOwner;`
    $results.Add($result) ;`
    $current++;`
} 
Write-Host "Top 10 bad performance"
$results | sort Performance -Descending | select -First 10 ViewName, Entity, Columns, TotalRecords, Owner, Performance | ft

Write-Host "Top 10 returned records per view"
$results | sort TotalRecords -Descending | select -First 10 ViewName, Entity, Columns, TotalRecords, Owner, Performance | ft

Write-Host "Top 10 column counts per view"
$results | sort Columns -Descending | select -First 10 ViewName, Entity, Columns, TotalRecords, Owner, Performance | ft
