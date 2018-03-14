#close a case 

$caseid="9EFFD829-8D95-E611-80F3-5065F38B3191"
$closure = New-Object Microsoft.Xrm.Sdk.Entity
$closure.LogicalName = "incidentresolution"
$closure.Attributes.Add("subject","closure subject")
$closure.Attributes.Add("incidentid",(New-CrmEntityReference -EntityLogicalName incident -id $caseid))
$closure.Id = new-guid #closure activityid 
$caseClose = new-object Microsoft.Crm.Sdk.Messages.CloseIncidentRequest
$caseClose.Status = New-CrmOptionSetValue -Value -1
$caseClose.IncidentResolution = $closure
$conn.ExecuteCrmOrganizationRequest($caseClose)
