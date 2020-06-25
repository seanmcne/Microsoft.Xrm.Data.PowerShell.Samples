New-CrmRecord -EntityLogicalName systemuser -Fields @{
  "firstname"="JaneDoe";
  "lastname"="App";
  "internalemailaddress"="appuser@domain.com";
  "applicationid"=[Guid]"cb94b033-d8d2-4bd3-a5fd-0def181145e2";
  "businessunitid"=(New-CrmEntityReference -Id (Invoke-CrmWhoAmI).BusinessUnitId -EntityLogicalName systemuser)
}
