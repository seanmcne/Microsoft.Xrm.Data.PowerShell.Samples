#delete Solution example

Import-Module Microsoft.Xrm.Data.Powershell


$solutionUniqueName = 'powerbitest' 

$solutionsFound = Get-CrmRecords -EntityLogicalName solution -FilterAttribute uniquename -FilterOperator eq -FilterValue $solutionName

if($solutionsFound.Count -gt 1){
  throw "more than one solution found!"
}
elseif($solutionsFound.Count -eq 0){
  throw "No Solutions Found!"
}

#ID of the solution to delete
$SolutionId = $solutionsFound.CrmRecords[0].ReturnProperty_Id

$conn.Delete("solution", $SolutionId)

#check for errors or problems with the operation
if($conn.LastCrmException -ne $null){
            throw $conn.LastCrmException
}
elseif($conn.LastCrmError -ne ""){
            throw $conn.LastCrmError
}
else{
            Write-Output "Success"
}
