#this script will remove the role below from ALL enabled users in a CDS/D365 environment 

$roleToRemove = "Salesperson"

$UserSourceFetch = "<fetch version=""1.0"" output-format=""xml-platform"" mapping=""logical"" distinct=""true"">
    <entity name=""role"">
    <attribute name=""name"" />
    <attribute name=""businessunitid"" />
    <attribute name=""roleid"" />
    <filter type=""and"">
        <condition attribute=""name"" operator=""eq"" value=""$roleToRemove"" />
    </filter>
    <link-entity name=""systemuserroles"" from=""roleid"" to=""roleid"" visible=""false"" intersect=""true"">
        <link-entity name=""systemuser"" from=""systemuserid"" to=""systemuserid"" alias=""user"">
        <attribute name=""systemuserid"" />
        <attribute name=""domainname"" />
        <filter type=""and"">
            <condition attribute=""isdisabled"" operator=""eq"" value=""0"" />
        </filter>
        </link-entity>
    </link-entity>
    </entity>
</fetch>";

#Get users roles along with other info
$list = (Get-CrmRecordsByFetch -Fetch $UserSourceFetch -conn $connSource).CrmRecords | Select `
    name, `
    roleid,
    @{Name="businessunitid";Expression={$_.businessunitid_Property.Value.Id}}, `
    @{Name="businessunitname";Expression={$_.businessunitid_Property.Value.Name}}, `
    @{Name="systemuserid";Expression={$_."user.systemuserid"}}, `
    @{Name="domainname";Expression={$_."user.domainname"}}

# |% is a shortcut of "ForEach(item $_ in $list)"
$list |%{
  Write-Output "Removing $($_.name) $($_.roleid) from user:$($_.domainname) $($_.systemuserid)"
  #remove security role cmdlet call goes here 
  Remove-CrmSecurityRoleFromUser -UserId $_.systemuserid -SecurityRoleId $_.roleid
}
