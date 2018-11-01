#Overview
New-CRMRecordsBatch is a cmdlet for the creation of many records at a time. It uses the REST API method ExecuteBatch to send a batch of records for creation, resulting in less calls to the CRM server and a more efficient job.

To use, run the script, NewCRMRecordsBatch.ps1, this will add the function, New-CrmRecordsBatch to your PowerShell session. You can then use Get-Help to learn more. 