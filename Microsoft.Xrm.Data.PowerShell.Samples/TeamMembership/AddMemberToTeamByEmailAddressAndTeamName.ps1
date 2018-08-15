
function addUserToTeam{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [string]$userUpn, 
        [parameter(Mandatory=$true)]
        [string]$teamName
    )
    $teams = get-crmrecords -EntityLogicalName team -Fields name -FilterAttribute name -FilterOperator like -FilterValue $teamName #
    if($teams.Count -gt 1){
        throw "Error - more than one team returned for: $teamName"
    }else{
        Write-Output "Found team $teamName with Id: $($teams.CrmRecords[0].teamid)"
    }
    $fetch=
@"
        <fetch version='1.0' output-format='xml-platform' mapping='logical' distinct='false' no-lock='true'>
                <entity name='systemuser'>
                    <attribute name='internalemailaddress' /><attribute name='domainname' /><attribute name='systemuserid' />
                    <filter type='or'>
                        <condition attribute='domainname' operator='like' value='$userUpn@%' />
                        <condition attribute='internalemailaddress' operator='like' value='$userUpn@%' />
                    </filter>
                </entity>
            </fetch>
"@
    $users = Get-CrmRecordsByFetch $fetch -Verbose
    if($users.Count -gt 1){
        throw "Error - more than one user was returned for: $userUpn"
    }else{
        Write-Output "Found user $userUpn with Id: $($users.CrmRecords[0].systemuserid)"
    }
    if($teams.Count -eq 0 -and $users.Count -eq 0){
        $teamMembers = @(); 
        $teamMembers += @($users.CrmRecords[0].systemuserid)
        $AddMember = new-object Microsoft.Crm.Sdk.Messages.AddMembersTeamRequest
        $AddMember.TeamId = $teams.CrmRecords[0].teamid
        $AddMember.MemberIds = $teamMembers 
        $conn.ExecuteCrmOrganizationRequest($AddMember)
        if($conn.LastCrmException -ne $null){
            throw $conn.LastCrmException
        }
        if($conn.LastCrmError -ne $null){
                    throw $conn.LastCrmError
        }
    }
    else {
        return;
    }
}
