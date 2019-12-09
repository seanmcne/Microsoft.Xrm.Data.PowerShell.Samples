using namespace Microsoft.Xrm.Sdk
using namespace Microsoft.Xrm.Sdk.Messages
using namespace Microsoft.Xrm.Sdk.Metadata

connect-crmonline -serverurl org.crm.dynamics.com -forceoauth 

$request = New-Object CreateOneToManyRequest -Property @{
	OneToManyRelationship = New-Object OneToManyRelationshipMetadata -Property @{
		ReferencedEntity = "contact"
        ReferencingEntity = "contact"
        SchemaName = "new_contact_contact_managerid"
		IsHierarchical = $true
        AssociatedMenuConfiguration = New-Object AssociatedMenuConfiguration -Property @{
            Behavior = [AssociatedMenuBehavior]::UseLabel
            Group = [AssociatedMenuGroup]::Details
            Label = New-Object Label @("Manager", 1033)
            Order = 10000
        }
        CascadeConfiguration = New-Object CascadeConfiguration -Property @{
            Assign = [CascadeType]::NoCascade
            Delete = [CascadeType]::RemoveLink
            Merge = [CascadeType]::NoCascade
            Reparent = [CascadeType]::NoCascade
            Share = [CascadeType]::NoCascade
            Unshare = [CascadeType]::NoCascade
        }
	}
	Lookup = New-Object LookupAttributeMetadata -Property @{
        SchemaName = "new_managerid"
        DisplayName = New-Object Label @("Manager", 1033)
        RequiredLevel = New-Object AttributeRequiredLevelManagedProperty @([AttributeRequiredLevel]::None)
        Description = New-Object Label @("The contact's manager", 1033)
    }
}

$conn.Execute($request)

$quickFormId = (Get-CrmRecords `
	-conn $conn `
	-EntityLogicalName systemform `
	-FilterAttribute name `
	-FilterOperator eq `
	-FilterValue "Contact Quick Form" `
	-Fields @( "formid" ) `
	-TopCount 1
	).CrmRecords.formid

New-CrmRecord `
	-conn $conn `
	-EntityLogicalName hierarchyrule `
	-Fields @{
		name = "new_contact_manager"
		primaryentityformid = $quickFormId
		primaryentitylogicalname = "contact"
	}

Publish-CrmAllCustomization -conn $connection
