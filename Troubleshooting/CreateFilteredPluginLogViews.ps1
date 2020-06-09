#create an all up  view
$querytype=0
$name = "Exception Logs"
$returnedtypecode = "plugintracelog"
$layoutxml = '<grid name="resultset" object="4619" jump="messagename" select="1" icon="1" preview="0"><row name="result" id="plugintracelogid"><cell name="typename" width="200"/><cell name="messagename" width="75"/><cell name="performanceexecutionstarttime" width="125"/><cell name="performanceconstructorstarttime" width="100"/><cell name="depth" width="50"/><cell name="performanceexecutionduration" width="75"/><cell name="mode" width="100"/><cell name="primaryentity" width="100"/><cell name="requestid" width="300"/><cell name="correlationid" width="150"/></row></grid>'
$fetchxml = '<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false"><entity name="plugintracelog"><attribute name="plugintracelogid"/><attribute name="messagename"/><attribute name="typename"/><attribute name="performanceexecutionstarttime"/><attribute name="requestid"/><attribute name="primaryentity"/><attribute name="mode"/><attribute name="performanceexecutionduration"/><attribute name="depth"/><attribute name="correlationid"/><attribute name="performanceconstructorstarttime"/><order attribute="performanceexecutionstarttime" descending="true"/></entity></fetch>'

New-CrmRecord userquery @{"name"="$name";"returnedtypecode"="$returnedtypecode";"layoutxml"="$layoutxml";"fetchxml"="$fetchxml";"querytype"=$querytype}

#create an exceptions only view
$querytype=0
$name = "Exception Logs"
$returnedtypecode = "plugintracelog"
$layoutxml = '<grid name="resultset" object="4619" jump="messagename" select="1" icon="1" preview="0"><row name="result" id="plugintracelogid"><cell name="typename" width="200"/><cell name="messagename" width="75"/><cell name="performanceexecutionstarttime" width="125"/><cell name="performanceconstructorstarttime" width="100"/><cell name="depth" width="50"/><cell name="performanceexecutionduration" width="75"/><cell name="mode" width="100"/><cell name="primaryentity" width="100"/><cell name="requestid" width="300"/><cell name="correlationid" width="150"/></row></grid>'
$fetchxml = '<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false"><entity name="plugintracelog"><attribute name="plugintracelogid"/><attribute name="messagename"/><attribute name="typename"/><attribute name="performanceexecutionstarttime"/><attribute name="requestid"/><attribute name="primaryentity"/><attribute name="mode"/><attribute name="performanceexecutionduration"/><attribute name="depth"/><attribute name="correlationid"/><attribute name="performanceconstructorstarttime"/><order attribute="performanceexecutionstarttime" descending="true"/><filter type="and"><condition attribute="exceptiondetails" operator="like" value="%exception%"/></filter></entity></fetch>'

New-CrmRecord userquery @{"name"="$name";"returnedtypecode"="$returnedtypecode";"layoutxml"="$layoutxml";"fetchxml"="$fetchxml";"querytype"=$querytype}

#create a success only view 
$querytype=0
$name = "Success Logs"
$returnedtypecode = "plugintracelog"
$layoutxml = '<grid name="resultset" object="4619" jump="messagename" select="1" icon="1" preview="0"><row name="result" id="plugintracelogid"><cell name="typename" width="200"/><cell name="messagename" width="75"/><cell name="performanceexecutionstarttime" width="125"/><cell name="performanceconstructorstarttime" width="100"/><cell name="depth" width="50"/><cell name="performanceexecutionduration" width="75"/><cell name="mode" width="100"/><cell name="primaryentity" width="100"/><cell name="requestid" width="300"/><cell name="correlationid" width="150"/></row></grid>'
$fetchxml = '<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false"><entity name="plugintracelog"><attribute name="plugintracelogid"/><attribute name="messagename"/><attribute name="typename"/><attribute name="performanceexecutionstarttime"/><attribute name="requestid"/><attribute name="primaryentity"/><attribute name="mode"/><attribute name="performanceexecutionduration"/><attribute name="depth"/><attribute name="correlationid"/><attribute name="performanceconstructorstarttime"/><order attribute="performanceexecutionstarttime" descending="true"/><filter type="and"><condition attribute="exceptiondetails" operator="like" value=""/></filter></entity></fetch>'

New-CrmRecord userquery @{"name"="$name";"returnedtypecode"="$returnedtypecode";"layoutxml"="$layoutxml";"fetchxml"="$fetchxml";"querytype"=$querytype}
