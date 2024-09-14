Encrypt plain text credentials with Export-Clixml in scripts. You have 2 options. You can choose to encrypt a file so that only a specific user on a specific server can decrypt the file, or you can choose to encrypt a file that any user can decrypt.

#### Example where you need the specific user on the specific server to decrypt the file

1. You want to encrypt the credentials of a local account **CLIENT01\Admin** which you can use for making a drive mapping
2. Your server that hosts the script is **SERVER01**
3. The user that runs the script is **SVC_USER01**

**Run PowerShell as user SVC_USER01 on SERVER01**

```powershell
# Create encrypted file
Get-Credential | Export-Clixml -Path "<file>.cred" # Provide credentials for CLIENT01\Admin

# Use the encrypted file
$Cred = Import-Clixml -Path "<file>.cred" # On SERVER01 with user SVC_USER01 you can store the credentials in a variable
New-PSDrive -Name "<name>" -Root "<destination>" -PSProvider "FileSystem" -Credential $Cred # Use the credentials to make a drive mapping
```

#### Example where any user can decrypt the file

1. You want to encrypt the credentials of a local account **CLIENT01\Admin** which you can use for making a drive mapping

```powershell
# Create encrypted file
(Get-Credential).Password | ConvertFrom-SecureString -Key (1..16) | Out-File "<file>.cred" # Create the file

# Use the encrypted file
$Password = Get-Content "<file>.cred" | ConvertTo-SecureString -Key (1..16)
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "<username>", $Password
New-PSDrive -Name "<name>" -Root "<destination>" -PSProvider "FileSystem" -Credential $Cred # Use the credentials to make a drive mapping
```