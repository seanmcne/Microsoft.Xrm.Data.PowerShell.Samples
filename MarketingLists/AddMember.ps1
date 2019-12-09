#https://msdn.microsoft.com/en-us/library/microsoft.crm.sdk.messages.addmemberlistrequest.aspx

Import-Module Microsoft.Xrm.Data.Powershell

#ID of the marketing list you want to add to 
$MarketingListId = "107E563B-7D21-40A5-AF6B-C8975E9C3860"

#ID of a record that would belong in the selected marketing list 
$RelatedEntityId = "C69F9B23-F3B2-403F-A1CF-C81FEF71126F" 

$AddMember = new-object Microsoft.Crm.Sdk.Messages.AddMemberlistRequest
$AddMember.EntityId = $RelatedEntityId 
$AddMember.ListId = $MarketingListId

$conn.ExecuteCrmOrganizationRequest($AddMember)
