# Created by: Sanjin Tajic
#
# Copyright © 2017 Microsoft Corporation. All Rights Reserved.
# This code released under the terms of the Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys' fees, that arise or result from the use or distribution of the Sample Code

<# 

Using the RetrieveDataEncryptionKey (https://msdn.microsoft.com/en-us/library/mt608110.aspx) and
SetDataEncryptionKey (https://msdn.microsoft.com/en-us/library/mt608039.aspx) actions to interact with the organization.

An alternative approach by using the SetDataEncryptionKeyRequest can be found here: https://github.com/seanmcne/Microsoft.Xrm.Data.PowerShell/issues/244

#>

# Read current organization encryption key
Invoke-CrmAction -Name "RetrieveDataEncryptionKey"

# Set and activate a new key
Invoke-CrmAction -Name "SetDataEncryptionKey" -Parameters @{EncryptionKey = "<KEY>"; ChangeEncryptionKey = $true}