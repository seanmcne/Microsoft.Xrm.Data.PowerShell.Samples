import-module Microsoft.Xrm.Data.Powershell


<#
.Synopsis
   Create many records with less calls to the CRM server.
.DESCRIPTION
   Uses the ExecuteBatch method to send multiple CreateRequest objects to the server at a time using the Web API.  
   This will only work on CRM servers where Batch Operations are Available. 
   You need to make an array of [Microsoft.Xrm.Sdk.Entity] with all of the attributes you want for each object first, then pass that array to this cmdlet.
    New-CRMRecordsBatch will break up your array into batches and send them to the CRM server for processing. 
.EXAMPLE
   $accounts = Import-Csv -Path "C:\dataAug-24-2018.csv"

[Microsoft.Xrm.Sdk.Entity[]]$accountEntities = @(
    foreach($account in $accounts)
    {
        $entity = [Microsoft.Xrm.Sdk.Entity]::new('account')
        $entity.Attributes['name'] = $account.Company
        $entity.Attributes['telephone1'] = $account.Phone
        $entity.Attributes['address1_line1'] = $account.Street
        $entity.Attributes['address1_postalcode'] = $account.PostCode
        $entity.Attributes['address1_city'] = $account.City
        $entity
    }
)

$results = New-CRMRecordsBatch -Entities $accountEntities
$results
...

In this example, we create an array of Entities from a CSV file that contains account information and pass them into New-CRMRecordsBatch. 
What is not shown here is the Server connection which was created before New-CRMRecordBatch was run. 
Below is the output of the $results variable, it is a Microsoft.Xrm.Sdk.Messages.ExecuteMultipleResponse and contains a lot of information about the records that were created by the server which may be useful to you. 


IsFaulted     : False
Responses     : {Microsoft.Xrm.Sdk.ExecuteMultipleResponseItem, Microsoft.Xrm.Sdk.ExecuteMultipleResponseItem, Microsoft.Xrm.Sdk.ExecuteMultipleResponseItem, 
                Microsoft.Xrm.Sdk.ExecuteMultipleResponseItem...}
ResponseName  : ExecuteMultiple
Results       : {[IsFaulted, False], [Responses, Microsoft.Xrm.Sdk.ExecuteMultipleResponseItemCollection]}
ExtensionData : System.Runtime.Serialization.ExtensionDataObject

.EXAMPLE
   $accounts = Import-Csv -Path "C:\dataAug-24-2018.csv"

[Microsoft.Xrm.Sdk.Entity[]]$accountEntities = @(
    foreach($account in $accounts)
    {
        $entity = [Microsoft.Xrm.Sdk.Entity]::new('account')
        $entity.Attributes['name'] = $account.Company
        $entity.Attributes['telephone1'] = $account.Phone
        $entity.Attributes['address1_line1'] = $account.Street
        $entity.Attributes['address1_postalcode'] = $account.PostCode
        $entity.Attributes['address1_city'] = $account.City
        $entity
    }
)

New-CRMRecordsBatch -Entities $accountEntities -ReturnResults:$false


This is exactly the same as Example 1 except that no results are returned by the server. How the operation went will be a mystery to you. 
.INPUTS
   Microsoft.Xrm.Sdk.Entity[],Microsoft.Xrm.Tooling.Connector.CrmServiceClient
.OUTPUTS
   Microsoft.Xrm.Sdk.Messages.ExecuteMultipleResponse
#>
function New-CRMRecordsBatch{
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Messages.ExecuteMultipleResponse])]
    Param
    (
        #The [Microsoft.Xrm.Sdk.Entity[]] you wish to create goes here.
                [Parameter(Mandatory=$true,
                   Position=0)]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Entities,

        #A connection to your CRM organization. Use $conn = Get-CrmConnection <Parameters> to generate it.
        [Parameter(Mandatory=$false)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $conn,
        #Number of records to send to the CRM server at a time. If this is set too high, the server will return $null..
        [Parameter(Mandatory=$false)]
        [int]
        $NumberOfRecordsPerBatch = 100,

        #By default, this cmdlet will tell the CRM server to return the results of the records back to you. If set to false, the server will return no results. 
        [Parameter(Mandatory=$false,
                   Position=1)]
        [bool]$ReturnResults=$true,

        #Indicates whether the server side process should continue on error. By default, if one record fails inside a batch, the whole batch will fail and be rolled back.  If you use this switch, the CRM server will ignore process everything in the batch except the failed record. 
        [switch]$ContinueOnError
    )

    Begin
    {
        if(!$conn.IsBatchOperationsAvailable){throw "Batch operations are not available for this server."}
        #write-progress doesn't like the math if the batch size is larger than the entity count.
        if($Entities.count -lt $NumberOfRecordsPerBatch){$NumberOfRecordsPerBatch = $Entities.count}
    }
    Process
    {
        
        #we need to break the jobs up into small amounts. If you do to many at a time, it will not work and will return null.
        $end = 0
        while ($end -lt $Entities.count)
        {
            $start = $end
            $end += $NumberOfRecordsPerBatch
            Write-Progress -Activity 'Executing Batch' -Status "$end of $($Entities.count)" -PercentComplete ($end/$Entities.count*100)
            #We need to create a batch job with the CrmServiceClient, CreateBatchOperationRequest does this, but just returns a GUID.
            #GetBatchById() then returns the Microsoft.Xrm.Tooling.Connector.RequestBatch object which is where we can stuff an array of entities to be created in the CRM.
            $requestBatch = $conn.GetBatchById($conn.CreateBatchOperationRequest("EntityList Index $start to $end",$ReturnResults,$ContinueOnError))
            
            Write-Verbose "Adding $NumberOfRecordsPerBatch Items to Batch"
            foreach($entity in $Entities[$start..$end])
            {
                #put the Entity inside the createrequest which creates an Microsoft.Xrm.Sdk.OrganizationRequest object
                $createRequest = New-Object Microsoft.Xrm.Sdk.Messages.CreateRequest
                $createRequest.Target = $entity
                
                #put the Microsoft.Xrm.Sdk.OrganizationRequest inside a BatchItemOrganizationRequest object and add it to the request batch.
                $item = [Microsoft.Xrm.Tooling.Connector.BatchItemOrganizationRequest]::new()
                $item.Request = $createRequest
                
                $requestBatch.BatchItems.Add($item)
            }
            Write-Verbose 'Executing Batch on Server. Awaiting Response'
            #send the batch job to the CRM server for processing.
            $response = $conn.ExecuteBatch($RequestBatch.BatchId)
            #error handling.
            if($response.IsFaulted){throw $response.Responses[0].Fault}
            elseif(($null -eq $response) -and ($ReturnResults -eq $true)){throw "Server returned null. Try a smaller batch size."}
            else{$response}
        }

        
    }
    End
    {
        
    }
}