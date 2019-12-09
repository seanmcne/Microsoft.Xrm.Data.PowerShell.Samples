#Note: An admin can get the business unit ID from either get-records -entitylogicalname businessunit – or invoke-crmwhoami 
#Note: Update the firstname/lastname

Import-Module Microsoft.Xrm.Data.PowerShell

Connect-crmonline -serverurl org.crm.dynamics.com 

#set the new stub users upn
$upn="testuser6@yourdomain.onmicrosoft.com"

#set the new users business unit - this can't be changed until they're sync'd later - choose their stub user BU wisely
$businessunitid = New-CrmEntityReference -EntityLogicalName businessunit -Id c49628fc-7a16-e611-80e1-5065f38a2b51

#create the stub user 
New-CrmRecord -EntityLogicalName systemuser -Fields @{
  "firstname"="John";
  "lastname"="Doe";
  "domainname"=$upn;
  "internalemailaddress"=$upn;
  "accessmode"=(New-CrmOptionSetValue 0); #Might need to update this in the future 
  "businessunitid"=$bu;
  "islicensed"=$false;
  "issyncwithdirectory"=$false
}
