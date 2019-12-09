#Install-Module Microsoft.Xrm.Data.Powershell -scope CurrentUser
Import-Module Microsoft.Xrm.Data.Powershell 

#login w/ oAuth to support MFA
Connect-Crmonline -ServerUrl environment.crm.dynamics.com -ForceOAuth 

#query for all webresources that start with mspfe_
#this query may take quite some time to return as all files and contents will be retrieved 
#in the future it might be best to use fetch and only dump unmanaged and specific types of webresources to execute the query faster
$webResourceFiles = Get-CrmRecords -EntityLogicalName webresource -Fields * -AllRows -FieldName name -FilterOperator like -FilterValue "mspfe_%"

#I couldn't figure out a better way to force the creation of a file when converting from base64 content
#foreach file, force create an empty file with 0 bytes
#then write all base64 bytes into the file

$webResourceFiles.CrmRecords|%{
  $DirectoryToWriteTo = "c:\users\yourusername\WebResourceRoot"
  $itemName = "$DirectoryToWriteTo\$(($_.name).Replace("/","\"))"
  write-output "FileName: $itemName"
  New-Item -ItemType File -Path $itemName -Force
  $bytes = [Convert]::FromBase64String($_.content)
  [IO.File]::WriteAllBytes($itemName, $bytes)
}
