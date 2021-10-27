Function Add-CRMHolidayDate () {
    param(
	    [Parameter(Mandatory = $false)]    [String]$CalendarName = "Holidays",
	    [Parameter(Mandatory = $false)]    [datetime]$Date = "12/25/2021", 
        [Parameter(Mandatory = $true)]     [String]$Name = "Christmas"
    )
    
    # Verify that the calendar exist
    $Calendar = (Get-CrmRecords -EntityLogicalName calendar -Fields * -FilterAttribute type -FilterOperator eq -FilterValue 2).CrmRecords | Where-Object name -match $CalendarName
    if (-not $Calendar) {
        throw "The calendar named `"$CalendarName`" does not exist."
        return $false           
    }

    # Get the calendar guid and calendar rules
    $CalendarId = $calendar.calendarid.Guid
    [Microsoft.Xrm.Sdk.EntityCollection]$calendarRules = $calendar.calendarrules
    IF ($calendarRules.Entities.Count -eq 0) {
        [Microsoft.Xrm.Sdk.EntityCollection]$calendarRules = [Microsoft.Xrm.Sdk.EntityCollection]::new()
    }
    
    #Check and verify that the date does not exist in the Calendar Rules
    if (-not ($calendarRules.Entities.Attributes | where-object {$_.key -match "starttime"} | where {(Get-Date -Date $_.Value -Format "yyyyMMdd") -match (Get-Date -Date $Date -Format "yyyyMMdd")})) {
        #Create a inner calendar object
        write-output "Adding date `"$Name`" on $Date to $CalendarName."
        $newInnerCalendar = New-Object -TypeName Microsoft.Xrm.Sdk.Entity -ArgumentList "calendar"
        $newInnerCalendar["businessunitid"] = $Calendar.businessunitid_Property.Value
        $newInnerCalendarId = $global:conn.Create($newInnerCalendar)

        # Create a new calendarrule entity
        $calendarRule = [Microsoft.Xrm.Sdk.Entity]::new("calendarrule")
        $calendarRule["name"] = $Name
        $calendarRule["duration"] = 1440;
        $calendarRule["extentcode"] = 1;
        $calendarRule["pattern"] = "FREQ=DAILY;INTERVAL=1;COUNT=1";
        $calendarRule["rank"] = 0;
        $calendarRule["timezonecode"] = -1
        $calendarRule["innercalendarid"] = [Microsoft.Xrm.Sdk.EntityReference]::new("calendar", $newInnerCalendarId)
        $calendarRule["calendarid"] = [Microsoft.Xrm.Sdk.EntityReference]::new("calendar", $CalendarId)
        $calendarRule["starttime"] = [System.DateTime]::new($Date.date.Year, $Date.date.Month, $Date.date.Day, 0, 0, 0, [System.DateTimeKind]::Utc)

        # assign the calendar rule back to the calendar
        $calendarRules.Entities.add($calendarRule)

        # Update calander to refresh the calendar rules collection
        $updateUserCalendar = [Microsoft.Xrm.Sdk.Entity]::new("calendar", $CalendarId);
        $updateUserCalendar["calendarrules"] = $calendarRules;
        $global:conn.Update($updateUserCalendar)
    } else {
        Write-Warning "The date `"$Name`" on `"$Date`" already exist."
    }
}
