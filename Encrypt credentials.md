### Option 1: Encrypt credentials that any user can decrypt

```powershell
# Create file with encrypted credentials
(Get-Credential).Password | ConvertFrom-SecureString -Key (1..16) | Out-File "<file>.cred"

# Decrypt credentials from file
$Username = "<username>"
$Password = Get-Content "<file>.cred" | ConvertTo-SecureString -Key (1..16)
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
```

### Option 2: Encrypt credentials that only a specific user on a specific server can decrypt (Export-Clixml)

```powershell
# Create file with encrypted credentials (log in as the user on the server that will run this script)
Get-Credential | Export-Clixml -Path "<file>.cred"

# Decrypt credentials from file (again, log in as the user on the server that will run this script)
$Cred = Import-Clixml -Path "<file>.cred"
```

For option 1, we use the '**ConvertFrom-SecureString**' PowerShell cmdlet with a **16-byte key** so that the encryption doesn't get tied to the current user's credentials. This way, any user could decrypt the credentials. Not the safest way, but better than plaintext credentials.

For option 2, we use the '**Export-Clixml**' PowerShell cmdlet so that only the user who encrypted the credentials on the specific server can decrypt the credentials.

In the scripts above, the variable '**$Cred**' becomes available. This variable can be used in your scripts to make, for example, a drive mapping.