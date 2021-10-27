Connect-CrmOnline -ServerUrl environment.crm.dynamics.com -username someone@domain.com -verbose 

#example is for UnResolveEmailAddressIfMultipleMatch setting of false 

$updateFields = @{}

$updateFields.Add("UnResolveEmailAddressIfMultipleMatch".toLower() ,$false)

Set-CrmRecord -conn $conn -EntityLogicalName organization -Id (Invoke-CrmWhoAmI).OrganizationId -Fields $updateFields
