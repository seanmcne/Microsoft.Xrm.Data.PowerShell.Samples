
Import-Module Microsoft.Xrm.Data.PowerShell

Connect-CrmOnline -ServerUrl <URL>

$qe = new-object Microsoft.Crm.Sdk.Messages.FetchXmlToQueryExpressionRequest 
$qe.FetchXml=@"
<fetch version='1.0' mapping='logical'>
  <entity name='account'>
    <attribute name='accountid' />
    <order attribute='name' descending='false' />
    <filter type='and'>
      <condition attribute='statecode' operator='eq' value='0' />
      <condition attribute='name' operator='eq' value='TEST' />
    </filter>
  </entity>
</fetch>
"@

$qeResponse=$conn.ExecuteCrmOrganizationRequest($qe) 
#TODO Check for failures on $conn.LastCrmError here

$bulkDeleteJobReq = new-object Microsoft.Crm.Sdk.Messages.BulkDeleteRequest 
$bulkDeleteJobReq.JobName = "My Awesome Bulk Delete Job Name" 
$bulkDeleteJobReq.QuerySet=$qeResponse.Query
#Recurrence Patterns Documentation: https://msdn.microsoft.com/en-us/library/gg328511.aspx
$bulkDeleteJobReq.RecurrencePattern = "FREQ-DAILY;"  
$bulkDeleteJobReq.RunNow = $false 

#start at 10pm
$bulkDeleteJobReq.StartDateTime = (Get-Date -Date "9/6/2018 10:00:00 PM") 
$bulkDelJobResponse=$conn.ExecuteCrmOrganizationRequest($bulkDeleteJobReq) 

#TODO Check for failures on $conn.LastCrmError here
