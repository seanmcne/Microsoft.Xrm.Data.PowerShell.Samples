# The following snippet will retrieve a Theme ID by name, and publish the theme.
# This can be useful to automate deplyoments, as themes are not part of solutions. 

# Fetch Theme ID by name
$themeId = (Get-CrmRecords -EntityLogicalName theme -FilterAttribute name -FilterOperator eq -FilterValue "CRM Blue Theme").CrmRecords[0].themeid

# Create reference to theme entity for the publish action
$theme = New-CrmEntityReference -EntityLogicalName theme -Id $themeId

# Publish Theme (https://docs.microsoft.com/en-us/dynamics365/customer-engagement/web-api/publishtheme?view=dynamics-ce-odata-9)
Invoke-CrmAction -Name "PublishTheme" -Parameters @{Target = $theme;}