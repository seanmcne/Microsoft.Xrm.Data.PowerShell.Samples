#
# Created by: Sanjin Tajic
#
#
# Copyright © 2017 Microsoft Corporation. All Rights Reserved.
#
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys' fees, that arise or result from the use or distribution of the Sample Code 

function CreateNote
{
    param
    (
        [string] $file,
        [hashtable] $entity
    )

    # The file attachment is stored as a base64-encoded string value in the database. Therefore, we need to encode the file first.
    $documentBody = [Convert]::ToBase64String((Get-Content -Path $file -Encoding Byte))

    # Add the encoded document to the hash describing the Note.
    $entity.Add("documentbody", $documentBody)

    # Create the record with all the provided data.
    New-CrmRecord -EntityLogicalName annotation -Fields $entity
}

# Connect to Dynamics 365. Use Connect-CrmOnPremDiscovery for On-Premise.
Connect-CrmOnline -ServerUrl environment.crm4.dynamics.com

# Sample Microsoft Word document location on local filesystem.
$fileName = "<FullPathToYourFile>\MyWordTemplate.docx";

# Create a hash containing the field value that describe the Note.
$entityFields = @{
    "subject" = "This note was created from PowerShell!"
    "mimetype" = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    # The file name of the file to be created, does not have to be the same as the one you uploaded.
    "filename" = "MyWordTemplate.docx"
}

# Run the sample
CreateNote -file $fileName -entity $entityFields
