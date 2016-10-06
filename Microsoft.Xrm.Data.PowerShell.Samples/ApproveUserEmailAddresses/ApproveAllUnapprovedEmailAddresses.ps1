
#If you don't have the module installed run the following command: 
# Install-Module Microsoft.xrm.data.powershell -Scope CurrentUser

Import-module Microsoft.xrm.data.powershell

#you can connect via the UI, for Azure Automation or scripted runs, use get-crmconnection instead 

Connect-CrmOnlineDiscovery -InteractiveMode

#the following are the values for emailrouteraccessapproval 
#0 Empty; 1 Approved; 2 PendingApproval; 3 Rejected 

#get all users that do not have an approved status
$unapprovedUsers = Get-CrmRecords -EntityLogicalName systemuser -FilterAttribute emailrouteraccessapproval -FilterOperator neq -FilterValue 1

$unapprovedUsers.CrmRecords | 
foreach{
  Write-Output "Approving $($_.systemuserid)"; 
  Approve-CrmEmailAddress -UserId $_.systemuserid;
}
