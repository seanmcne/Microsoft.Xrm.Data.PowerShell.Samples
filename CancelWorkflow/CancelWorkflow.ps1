# Copyright © Microsoft Corporation. All Rights Reserved.
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

# Create fetch query for waiting workflow
$fetch = @"
<fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='false'>
  <entity name='asyncoperation'>
    <attribute name='asyncoperationid' />
    <attribute name='statuscode' />
    <attribute name='statecode' />
    <order attribute='startedon' descending='true' />
    <filter type='and'>
      <condition attribute='operationtype' operator='eq' value='10' />
      <condition attribute='statuscode' operator='eq' value='10' />
    </filter>
  </entity>
</fetch>
"@

# Retrieve waiting workflow. Add -AllRows if you want to get all of them at once.
$jobs = Get-CrmRecordsByFetch -conn $conn -Fetch $fetch

# Operate each record
foreach($job in $jobs.CrmRecords)
{
    # Cancel workflow
    $job.statecode = New-CrmOptionSetValue 3
    $job.statuscode = New-CrmOptionSetValue 32
    Set-CrmRecord -conn $conn -CrmRecord $job
    # Then remove
    Remove-CrmRecord -conn $conn -EntityLogicalName asyncoperation -Id $job.asyncoperationid
}
