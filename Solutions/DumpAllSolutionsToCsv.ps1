#dump all solutions out of a list of enviornments for comparison. 

$user = "user@domain.onmicrosoft.com"
$orglist = "org1,org2,org3,org4"

$orglist.Split(",")|%{
    Write-Output "Processing org: $_"
    Connect-CrmOnline -ServerUrl "$_.crm.dynamics.com" -Username $user -ForceOAuth
    $allSolutions = (Get-CrmRecords -EntityLogicalName solution -Fields *)
    $allSolutions.CrmRecords|Out-File "$($conn.CrmConnectOrgUriActual.Host.Split(".")[0])SolutionsDump.csv"
}
