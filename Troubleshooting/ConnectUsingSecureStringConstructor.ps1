#Used to test connections using oAuth with ClientId and secret specifically using SecureString 
#done for testing before adding to the connect-crmonline 
#If you're using this in the future please check for direct support in connect-crmonline 

#in the current state you can use this in-place of connect-crmonline 
$ConnectionTimeoutInSeconds = 60
$TokenCachePath=$null
$RequireNewInstance=$True
$clientId = "97ee9b8b-a46a-4714-b167-7d1b884d7a3c" #replace with actual clientid from your tenant 
#convert plain text to SecureString for testing
$SecureString=ConvertTo-SecureString $secret -AsPlainText -Force
$url = [System.Uri]'https://url.crm.dynamics.com'

if($ConnectionTimeoutInSeconds -and $ConnectionTimeoutInSeconds -gt 0){
   $newTimeout = New-Object System.TimeSpan -ArgumentList 0,0,$ConnectionTimeoutInSeconds
   Write-Verbose "Setting new connection timeout of $newTimeout"
   #set the timeout on the MaxConnectionTimeout static 
   [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]::MaxConnectionTimeout = $newTimeout
}
#by default PowerShell will show Ssl3, Tls - since SSL3 is not desirable we will drop it and use Tls + Tls12
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls12

$global:conn = New-Object Microsoft.Xrm.Tooling.Connector.CrmServiceClient -ArgumentList @($url,$clientId,$SecureString,$RequireNewInstance,$TokenCachePath)
ApplyCrmServiceClientObjectTemplate($global:conn)  #applyObjectTemplateFormat
