#Promote a solution upgrade

Import-Module Microsoft.Xrm.Data.PowerShell

$solutionUniqueName = "solUniqueName"

$UpgradeSolutionRequest = new-object Microsoft.Crm.Sdk.Messages.DeleteAndPromoteRequest

$UpgradeSolutionRequest.UniqueName= $solutionUniqueName

$response= $conn.ExecuteCrmOrganizationRequest($UpgradeSolutionRequest)

#the unique identifier of the promoted solution

write-output $response.SolutionId
